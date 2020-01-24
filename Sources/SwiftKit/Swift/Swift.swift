//
//  Swift.swift
//
//  Created by Sereivoan Yong on 8/2/17.
//

import Foundation

public func printIfDEBUG(_ item: Any) {
  #if DEBUG
    print(item)
  #endif
}

public func deinitLog(_ object: Any) {
  printIfDEBUG("\(type(of: object)) deinit")
}

@discardableResult
@inlinable public func configure<T>(_ object: T, _ handler: (T) -> Void) -> T {
  handler(object)
  return object
}

@inlinable public func modify<T>(_ object: inout T, _ adjust: (inout T) -> Void) {
  var mutableObject = object
  adjust(&mutableObject)
  object = mutableObject
}

@inlinable public func modifying<T>(_ value: T, modify: (inout T) -> Void) -> T {
  var mutatingValue = value
  modify(&mutatingValue)
  return mutatingValue
}
