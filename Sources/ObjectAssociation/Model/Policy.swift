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
    case SWIFT_ASSOCIATION_ASSIGN = 0
    case SWIFT_ASSOCIATION_RETAIN_NONATOMIC = 1
    //    case SWIFT_ASSOCIATION_COPY_NONATOMIC = 3
    case SWIFT_ASSOCIATION_RETAIN = 769
    //    case SWIFT_ASSOCIATION_COPY = 771
}
