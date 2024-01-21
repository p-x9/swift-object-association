//
//  Ref.swift
//
//
//  Created by p-x9 on 2024/01/21.
//
//

import Foundation

class Ref<T> {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    deinit {
#if false
        print("deinit:", value)
#endif
    }
}
