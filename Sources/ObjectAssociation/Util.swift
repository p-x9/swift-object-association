//
//  Util.swift
//
//
//  Created by p-x9 on 2024/01/29.
//  
//
#if canImport(ObjectiveC)
import ObjectiveC
#endif

@inlinable
func autoreleasepoolIfAvailable<Result>(
    invoking body: () throws -> Result
) rethrows -> Result {
#if canImport(ObjectiveC)
    try autoreleasepool(invoking: body)
#else
    try body()
#endif
}
