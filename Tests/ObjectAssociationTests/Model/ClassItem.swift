//
//  ClassItem.swift
//
//
//  Created by p-x9 on 2024/01/21.
//  
//

import Foundation
import ObjectAssociation
import ObjectAssociationRuntime

class ClassItem {
    enum Keys {
        static var valueType: UInt8 = 0
        static var referenceType: UInt8 = 0
    }

    let id: UUID

    var valueType: String? {
        get {
            let val = getAssociatedObject(
                self,
                &ClassItem.Keys.valueType
            ) as? NSValue
            return val?.nonretainedObjectValue as? String
        }
        set {
            setAssociatedObject(
                self,
                &ClassItem.Keys.valueType,
                NSValue.init(nonretainedObject: newValue)
            )
        }
    }

    var referenceType: ClassItem? {
        get {
            getAssociatedObject(
                self,
                &ClassItem.Keys.referenceType
            ) as? ClassItem
        }
        set {
            setAssociatedObject(
                self,
                &ClassItem.Keys.referenceType,
                newValue
            )
        }
    }

    init(id: UUID) {
        self.id = id
    }

    init() {
        self.id = UUID()
    }

    deinit {
        print("deinit", id)
    }
}