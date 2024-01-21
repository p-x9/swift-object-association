//
//  Retain.swift
//
//
//  Created by p-x9 on 2024/01/21.
//
//

import Foundation

@_cdecl("swift_associated_object_retain")
public func swift_associated_object_retain(
    _ ptr: UnsafeRawPointer?
) {
    swift_reference_handle(ptr) {
        _ = Unmanaged<AnyObject>.fromOpaque($0).retain()
    }
}

@_cdecl("swift_associated_object_release")
public func swift_associated_object_release(
    _ ptr: UnsafeRawPointer?
) {
    swift_reference_handle(ptr) {
        Unmanaged<AnyObject>.fromOpaque($0).release()
    }
}

@_cdecl("swift_associated_object_autorelease")
public func swift_associated_object_autorelease(
    _ ptr: UnsafeRawPointer?
) {
    swift_reference_handle(ptr) {
        _ = Unmanaged<AnyObject>.fromOpaque($0).autorelease()
    }
}

private func swift_reference_handle(
    _ ptr: UnsafeRawPointer?,
    handler: (UnsafeRawPointer) -> Void
) {
    guard let ptr else { return }

#if false
    print(#function)
    let obj = Unmanaged<AnyObject>.fromOpaque(ptr).takeUnretainedValue()
    let old = CFGetRetainCount(obj)
    defer {
        print("Retain Count:", old - 1, "->", terminator: " ")
        print(CFGetRetainCount(obj) - 1)
    }
#endif

    handler(ptr)
}
