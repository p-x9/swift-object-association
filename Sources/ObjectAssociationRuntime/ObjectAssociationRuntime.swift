//
//  ObjectAssociationRuntime.swift
//
//
//  Created by p-x9 on 2024/01/21.
//
//

import Foundation

@_silgen_name("swift_initAssociations")
public func swift_initAssociations()

@_silgen_name("swift_removeAssociatedObjects")
public func swift_removeAssociatedObjects(_ object: AnyObject)

@_silgen_name("swift_setAssociatedObject")
public func swift_setAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer,
    _ value: AnyObject?,
    _ policy: Int
)

@_silgen_name("swift_getAssociatedObject")
public func swift_getAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer
) -> AnyObject?
