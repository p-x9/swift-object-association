//
//  reference.cpp
//  
//
//  Created by p-x9 on 2024/01/21.
//  
//

#include "../include/reference.hpp"
#include <vector>
#include <unordered_map>
#include <mutex>

// https://github.com/apple-oss-distributions/objc4/blob/main/runtime/objc-references.mm

enum {
    SWIFT_ASSOCIATION_SETTER_ASSIGN      = 0,
    SWIFT_ASSOCIATION_SETTER_RETAIN      = 1,
//    SWIFT_ASSOCIATION_SETTER_COPY        = 3,
    SWIFT_ASSOCIATION_GETTER_READ        = (0 << 8),
    SWIFT_ASSOCIATION_GETTER_RETAIN      = (1 << 8),
    SWIFT_ASSOCIATION_GETTER_AUTORELEASE = (2 << 8),
    SWIFT_ASSOCIATION_SYSTEM_OBJECT      = (1 << 16),
};

#define slowpath(x) (__builtin_expect(bool(x), 0))

class ObjcAssociation {
    uintptr_t _policy;
    void* _value;
public:
    ObjcAssociation(uintptr_t policy, void* value) : _policy(policy), _value(value) {}
    ObjcAssociation() : _policy(0), _value(0) {}
    ObjcAssociation(const ObjcAssociation &other) = default;
    ObjcAssociation &operator=(const ObjcAssociation &other) = default;
    ObjcAssociation(ObjcAssociation &&other) : ObjcAssociation() {
        swap(other);
    }

    inline void swap(ObjcAssociation &other) {
        std::swap(_policy, other._policy);
        std::swap(_value, other._value);
    }

    inline uintptr_t policy() const { return _policy; }
    inline void* value() const { return _value; }

        inline void acquireValue() {
            if (_value) {
                switch (_policy & 0xFF) {
                case SWIFT_ASSOCIATION_SETTER_RETAIN:
                    swift_associated_object_retain(_value);
                    break;
//                case SWIFT_ASSOCIATION_SETTER_COPY:
//                    _value = ((id(*)(id, SEL))objc_msgSend)(_value, @selector(copy));
//                    break;
                }
            }
        }

        inline void releaseHeldValue() {
            if (_value && (_policy & SWIFT_ASSOCIATION_SETTER_RETAIN)) {
                swift_associated_object_release(_value);
            }
        }
    
        inline void retainReturnedValue() {
            if (_value && (_policy & SWIFT_ASSOCIATION_GETTER_RETAIN)) {
                swift_associated_object_retain(_value);
            }
        }
    
        inline void* autoreleaseReturnedValue() {
            if (slowpath(_value && (_policy & SWIFT_ASSOCIATION_GETTER_AUTORELEASE))) {
                swift_associated_object_autorelease(_value);
                return _value;
            }
            return _value;
        }
};

typedef uintptr_t disguised_ptr_t;
inline disguised_ptr_t DISGUISE(void* value) { return ~uintptr_t(value); }

using ObjectAssociationMap = std::unordered_map<const void*, ObjcAssociation>;
using AssociationsHashMap = std::unordered_map<disguised_ptr_t, ObjectAssociationMap>;

class AssociationsManager {
    static std::mutex AssociationsManagerLock;
    static AssociationsHashMap _mapStorage;

public:
    AssociationsManager()   { AssociationsManagerLock.lock(); }
    ~AssociationsManager()  { AssociationsManagerLock.unlock(); }

    AssociationsHashMap &get() {
        return _mapStorage;
    }

    static void init() {
        _mapStorage = AssociationsHashMap();
    }
};

AssociationsHashMap AssociationsManager::_mapStorage;
std::mutex AssociationsManager::AssociationsManagerLock;


void
_objc_associations_init()
{
    AssociationsManager::init();
}

void *
_object_get_associative_reference(void *object, const void *key)
{
    ObjcAssociation association{};

    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());
        disguised_ptr_t disguised_object = DISGUISE(object);
        AssociationsHashMap::iterator i = associations.find(disguised_object);
        if (i != associations.end()) {
            ObjectAssociationMap &refs = i->second;
            ObjectAssociationMap::iterator j = refs.find(key);
            if (j != refs.end()) {
                association = j->second;
                association.retainReturnedValue();
            }
        }
    }

    return association.autoreleaseReturnedValue();
}

void
_object_set_associative_reference(void *object, const void *key, void *value, uintptr_t policy)
{
    // This code used to work when nil was passed for object and key. Some code
    // probably relies on that to not crash. Check and handle it explicitly.
    // rdar://problem/44094390
    if (!object && !value) return;

    //    if (object->getIsa()->forbidsAssociatedObjects())
    //        _objc_fatal("objc_setAssociatedObject called on instance (%p) of class %s which does not allow associated objects", object, object_getClassName(object));

    disguised_ptr_t disguised{DISGUISE(object)};
    ObjcAssociation association{policy, value};

    // retain the new value (if any) outside the lock.
    association.acquireValue();

    /* The original implementation also retains on the map */
    association.acquireValue();

    bool isFirstAssociation = false;
    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());

        if (value) {
            auto refs_result = associations.try_emplace(disguised, ObjectAssociationMap{});
            if (refs_result.second) {
                /* it's the first association we make */
                isFirstAssociation = true;
            }

            /* establish or replace the association */
            auto &refs = refs_result.first->second;
            auto result = refs.try_emplace(key, std::move(association));
            if (!result.second) {
                association.swap(result.first->second);
            }
        } else {
            auto refs_it = associations.find(disguised);
            if (refs_it != associations.end()) {
                auto &refs = refs_it->second;
                auto it = refs.find(key);
                if (it != refs.end()) {
                    association.swap(it->second);
                    refs.erase(it);
                    if (refs.size() == 0) {
                        associations.erase(refs_it);

                    }
                }
            }
        }
    }

    // Call setHasAssociatedObjects outside the lock, since this
    // will call the object's _noteAssociatedObjects method if it
    // has one, and this may trigger +initialize which might do
    // arbitrary stuff, including setting more associated objects.
    //    if (isFirstAssociation)
    //        object->setHasAssociatedObjects();

    // release the old value (outside of the lock).
    association.releaseHeldValue();
}

// Unlike setting/getting an associated reference,
// this function is performance sensitive because of
// raw isa objects (such as OS Objects) that can't track
// whether they have associated objects.
void
_object_remove_associations(void *object, bool deallocating)
{
    ObjectAssociationMap refs{};

    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());
        disguised_ptr_t disguised_object = DISGUISE(object);
        AssociationsHashMap::iterator i = associations.find(disguised_object);
        if (i != associations.end()) {
            refs.swap(i->second);

            // If we are not deallocating, then SYSTEM_OBJECT associations are preserved.
            bool didReInsert = false;
            if (!deallocating) {
                for (auto &ref: refs) {
                    if (ref.second.policy() & SWIFT_ASSOCIATION_SYSTEM_OBJECT) {
                        i->second.insert(ref);
                        didReInsert = true;
                    }
                }
            }
            if (!didReInsert)
                associations.erase(i);
        }
    }

    // Associations to be released after the normal ones.
    std::vector<ObjcAssociation*> laterRefs;

    // release everything (outside of the lock).
    for (auto &i: refs) {
        if (i.second.policy() & SWIFT_ASSOCIATION_SYSTEM_OBJECT) {
            // If we are not deallocating, then RELEASE_LATER associations don't get released.
            if (deallocating)
                laterRefs.push_back(&i.second);
        } else {
            i.second.releaseHeldValue();
        }
    }
    for (auto *later: laterRefs) {
        later->releaseHeldValue();
    }
}
