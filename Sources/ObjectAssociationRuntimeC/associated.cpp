//
//  associated.cpp
//  
//
//  Created by p-x9 on 2024/01/21.
//  
//

#include "include/associated.hpp"
#include "include/reference.hpp"
#include <stdbool.h>

void swift_initAssociations()
{
    _objc_associations_init();
}

void swift_removeAssociatedObjects(void *object)
{
    if (object/* && object->hasAssociatedObjects()*/) {
        _object_remove_associations(object, /*deallocating*/false);
    }
}

void swift_setAssociatedObject(void *object, const void *key, void *value, uint64_t policy)
{
    _object_set_associative_reference(object, key, value, policy);
}

void* swift_getAssociatedObject(void *object, const void *key)
{
    return _object_get_associative_reference(object, key);
}
