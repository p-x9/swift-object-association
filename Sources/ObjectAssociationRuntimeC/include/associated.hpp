//
//  associated.hpp
//  
//
//  Created by p-x9 on 2024/01/21.
//  
//

#ifndef associated_hpp
#define associated_hpp

#include <stdio.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void swift_removeAssociatedObjects(void *object);
void swift_setAssociatedObject(void *object, const void *key, void *value, uint64_t policy);
void* swift_getAssociatedObject(void *object, const void *key);

#ifdef __cplusplus
} /* end extern "C" */
#endif

#endif /* associated_hpp */
