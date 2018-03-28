import Foundation

internal func lazyAssociatedProperty <T: AnyObject> (_ host: AnyObject, key: UnsafeRawPointer,
                                                     factory: () -> T) -> T {
    
    if let value = objc_getAssociatedObject(host, key) as? T {
        return value
    }
    
    let value = factory()
    objc_setAssociatedObject(host, key, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return value
}


