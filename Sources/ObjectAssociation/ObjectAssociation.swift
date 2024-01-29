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
        let unmanaged = Unmanaged<Ref<Any?>>.fromOpaque(ptr)
        return unmanaged.takeUnretainedValue().value
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
    swift_setAssociatedObject(
        object,
        key,
        Ref(value),
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
