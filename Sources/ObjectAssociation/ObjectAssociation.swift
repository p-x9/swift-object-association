import ObjectAssociationRuntime
import class Foundation.NSNull


public func getAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer
) -> Any? {
    _ = _initAssociations
    let value = swift_getAssociatedObject(object, key)

    return value is NSNull ? nil : value
}

public func setAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer,
    _ value: Any
) {
    _ = _initAssociations
    swift_setAssociatedObject(
        object,
        key,
        value as AnyObject,
        Int(bitPattern: Policy.SWIFT_ASSOCIATION_RETAIN_NONATOMIC.rawValue)
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
