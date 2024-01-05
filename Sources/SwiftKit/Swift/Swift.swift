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

@inlinable
public func deinitPrint<T: AnyObject>(_ object: T) {
#if DEBUG
  if type(of: object) == T.self {
    print("\(T.self) deinit")
  }
#endif
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

@inlinable
public func isEqual<T, U: Equatable>(_ lhs: T, _ rhs: T, at keyPath: KeyPath<T, U>) -> Bool {
  return lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
}

/// Returns the first value.
///
///     let view = UIView()
///     if let firstSuperScrollview = first(view, of: UIScrollView.self, next: \.superview) {
///         print("The first super scroll view is \(firstSuperScrollview).")
///     }
@inlinable
public func first<T, U>(_ value: T?, of type: U.Type, next: (T) throws -> T?) rethrows -> U? {
  guard let value else { return nil }
  if let value = value as? U {
    return value
  }
  let nextValue = try next(value)
  return try first(nextValue, of: type, next: next)
}

/// Returns the first value.
///
///     let view = UIView()
///     if let firstRedSuperScrollview = first(view, of: UIScrollView.self, where: { $0.backgroundColor == .red }, next: \.superview) {
///         print("The first red super scroll view is \(firstRedSuperScrollview).")
///     }
@inlinable
public func first<T, U>(_ value: T?, of type: U.Type, where predicate: (U) throws -> Bool = { _ in true }, next: (T) throws -> T?) rethrows -> U? {
  guard let value else { return nil }
  if let value = value as? U, try predicate(value) {
    return value
  }
  let nextValue = try next(value)
  return try first(nextValue, of: type, where: predicate, next: next)
}

/// Returns the first value.
///
///     let view = UIView()
///     if let firstRedSuperScrollview = first(view, of: UIScrollView.self, where: \.backgroundColor, equalTo: .red, next: \.superview) {
///         print("The first red super scroll view is \(firstRedSuperScrollview).")
///     }
@inlinable
public func first<T, U, V: Equatable>(_ value: T?, of type: U.Type, where transform: (U) throws -> V, equalTo target: V, next: (T) throws -> T?) rethrows -> U? {
  return try first(value, of: type, where: { try transform($0) == target }, next: next)
}

/// Returns the first value.
///
///     let view = UIView()
///     if let firstRedSuperview = first(view, where: { $0.backgroundColor == .red }, next: \.superview) {
///         print("The first red super view is \(firstRedSuperview).")
///     }
@inlinable
public func first<T>(_ value: T?, where predicate: (T) throws -> Bool, next: (T) throws -> T?) rethrows -> T? {
  guard let value else { return nil }
  if try predicate(value) {
    return value
  }
  let nextValue = try next(value)
  return try first(nextValue, where: predicate, next: next)
}

/// Returns the first value.
///
///     let view = UIView()
///     if let firstRedSuperview = first(view, where: \.backgroundColor, equalTo: .red, next: \.superview) {
///         print("The first red super view is \(firstRedSuperview).")
///     }
@inlinable
public func first<T, U: Equatable>(_ value: T?, where transform: (T) throws -> U?, equalTo target: U, next: (T) throws -> T?) rethrows -> T? {
  return try first(value, where: { try transform($0) == target }, next: next)
}
