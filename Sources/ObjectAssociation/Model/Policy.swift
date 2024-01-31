//
//   Policy.swift
//
//
//  Created by p-x9 on 2024/01/21.
//  
//

import Foundation

// objc_AssociationPolicy
public enum swift_AssociationPolicy: UInt {
    /// Specifies an unsafe unretained reference to the associated object
    ///
    /// Same behavior as .`OBJC_ASSOCIATION_ASSIGN`
    case SWIFT_ASSOCIATION_ASSIGN = 0


    /// Specifies a strong reference to the associated object.
    ///
    /// Same behavior as .`OBJC_ASSOCIATION_RETAIN_NONATOMIC`
    case SWIFT_ASSOCIATION_RETAIN_NONATOMIC = 1

    //    case SWIFT_ASSOCIATION_COPY_NONATOMIC = 3

    /// Specifies a strong reference to the associated object.
    ///
    /// Same behavior as .`OBJC_ASSOCIATION_RETAIN`
    case SWIFT_ASSOCIATION_RETAIN = 769

    //    case SWIFT_ASSOCIATION_COPY = 771

    /// Specifies a weak reference to the associated object
    ///
    /// This policy is original and not existed in `objc_AssociationPolicy`
    case SWIFT_ASSOCIATION_WEAK = 0xFFFFFFFF
}
