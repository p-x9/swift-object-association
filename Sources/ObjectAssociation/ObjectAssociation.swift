import ObjectAssociationRuntime


public func getAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer
) -> Any? {
    _ = _initAssociations
    let ref = swift_getAssociatedObject(object, key) as? Ref<Any?>
    return ref?.value
}

public func setAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer,
    _ value: Any?
) {
    _ = _initAssociations
    swift_setAssociatedObject(
        object,
        key,
        Ref(value),
        Policy.SWIFT_ASSOCIATION_RETAIN_NONATOMIC.rawValue
    )
}

public func removeAssociatedObjects(_ object: AnyObject) {
    _ = _initAssociations
    swift_removeAssociatedObjects(object)
}

private var _initAssociations: Bool = {
    swift_initAssociations()
    return true
}()
