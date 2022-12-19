//
//  Swift.swift
//
//  Created by Sereivoan Yong on 8/2/17.
//

import Foundation

@usableFromInline
func _copy<T>(_ value: T) -> T {
  if let value = value as? NSCopying {
    return value.copy() as! T
  }
  return value
}

public func printIfDEBUG(_ item: Any) {
  #if DEBUG
    print(item)
  #endif
}

public func deinitLog(_ object: Any) {
  printIfDEBUG("\(type(of: object)) deinit")
}

@inlinable
public func address(of object: AnyObject) -> UnsafeMutableRawPointer {
  return Unmanaged<AnyObject>.passUnretained(object).toOpaque()
}

@discardableResult
@inlinable
public func configure<T>(_ object: T, _ handler: (T) -> Void) -> T {
  handler(object)
  return object
}

@inlinable
public func modify<T>(_ value: inout T, _ modify: (inout T) -> Void) -> T {
  modify(&value)
  return value
}

@inlinable
public func modifying<T>(_ value: T, _ modify: (inout T) -> Void) -> T {
  var value = _copy(value)
  modify(&value)
  return value
}

/// Returns the first value for the key path of the type on the value that satisfies the given predicate.
///
///     let view = UIView()
///     if let firstSuperScrollview = first(\.superview, of: UIScrollView.self, on: view) {
///         print("The first super scroll view is \(firstSuperScrollview).")
///     }
@inlinable
public func first<Value, T>(_ keyPath: KeyPath<Value, Value?>, of type: T.Type, on value: Value, where predicate: ((T) -> Bool)? = nil) -> T? {
  if let value = value[keyPath: keyPath] {
    if let value = value as? T, predicate?(value) ?? true {
      return value
    }
    return first(keyPath, of: type, on: value, where: predicate)
  }
  return nil
}

/// Returns the first value for the key path on the value that satisfies the given predicate.
///
///     let view = UIView()
///     if let firstRedSuperview = first(\.superview, on: view, where: { $0.backgroundColor == .systemRed }) {
///         print("The first red superview is \(firstRedSuperview).")
///     }
@inlinable
public func first<Value>(_ keyPath: KeyPath<Value, Value?>, on value: Value, where predicate: ((Value) -> Bool)? = nil) -> Value? {
  if let value = value[keyPath: keyPath] {
    if predicate?(value) ?? true {
      return value
    }
    return first(keyPath, on: value, where: predicate)
  }
  return nil
}
