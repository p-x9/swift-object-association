//
//  reference.hpp
//  
//
//  Created by p-x9 on 2024/01/21.
//  
//

#ifndef reference_hpp
#define reference_hpp

#include <stdio.h>
#include <stdbool.h>

extern "C" {
    void swift_initAssociations();
    void swift_associated_object_retain(void *object);
    void swift_associated_object_release(void *object);
    void swift_associated_object_autorelease(void *object);
}

#ifdef __cplusplus
extern "C"
#endif
void _objc_associations_init();

void* _object_get_associative_reference(void *object, const void *key);
void _object_set_associative_reference(void *object, const void *key, void *value, uintptr_t policy);
void _object_remove_associations(void *object, bool deallocating);

#endif /* reference_hpp */
