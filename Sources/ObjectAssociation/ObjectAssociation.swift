#if canImport(ObjectAssociationRuntime)
import ObjectAssociationRuntime
#endif


@inline(__always)
public func getAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer
) -> Any? {
    autoreleasepoolIfAvailable { () -> Any? in
        _ = _initAssociations
        guard let ptr = swift_getAssociatedObject(object, key) else { return nil }
        let unmanaged = Unmanaged<AnyObject>.fromOpaque(ptr)
        let value = unmanaged.takeUnretainedValue()

        if let ref = value as? Ref<Any> { return ref.value }
        return value
    }
}

@inline(__always)
public func setAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer,
    _ value: Any?,
    _ policy: swift_AssociationPolicy = .SWIFT_ASSOCIATION_RETAIN_NONATOMIC
) {
    _ = _initAssociations

    var valueToSet: AnyObject?
    if let value {
        if policy == .SWIFT_ASSOCIATION_ASSIGN {
            valueToSet = value as AnyObject
        } else {
            valueToSet = Ref(value)
        }
    }

    swift_setAssociatedObject(
        object,
        key,
        valueToSet,
        policy.rawValue
    )
}

@inline(__always)
public func removeAssociatedObjects(_ object: AnyObject) {
    _ = _initAssociations
    swift_removeAssociatedObjects(object)
}

private var _initAssociations: Bool = {
    swift_initAssociations()
    return true
}()
