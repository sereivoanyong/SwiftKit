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

@inlinable public func address(of object: AnyObject) -> UnsafeMutableRawPointer {
  return Unmanaged<AnyObject>.passUnretained(object).toOpaque()
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

/// Returns the first value for the key path of the type on the value that satisfies the given predicate.
///
///     let view = UIView()
///     if let firstSuperScrollview = first(\.superview, of: UIScrollView.self, on: view) {
///         print("The first super scroll view is \(firstSuperScrollview).")
///     }
@inlinable public func first<Value, T>(_ keyPath: KeyPath<Value, Value?>, of type: T.Type, on value: Value, where predicate: ((T) -> Bool)? = nil) -> T? {
  if let value = value[keyPath: keyPath] {
    if let value = value as? T, predicate?(value) ?? true {
      return value
    }
    return first(keyPath, of: type, on: value, where: predicate)
  }
  return nil
}
