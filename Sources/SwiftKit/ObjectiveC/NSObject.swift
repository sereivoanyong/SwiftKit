//
//  NSObject.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(ObjectiveC)

import ObjectiveC

extension NSObject {

  @inlinable
  public func valueIfResponds(forKey key: String) -> Any? {
    if responds(to: Selector(key)) {
      return value(forKey: key)
    }
    return nil
  }

  @inlinable
  public func setValueIfResponds(_ value: Any?, forKey key: String) {
    if responds(to: Selector(key)) {
      setValue(value, forKey: key)
    }
  }
}

extension NSObjectProtocol {

  @inlinable
  @discardableResult
  public func with<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>, _ value: Value) -> Self {
    self[keyPath: keyPath] = value
    return self
  }

  @inlinable
  @discardableResult
  public func configure(_ handler: (Self) -> Void) -> Self {
    handler(self)
    return self
  }

  @inlinable
  public func assigned(to object: inout Self?) -> Self {
    object = self
    return self
  }

  @inlinable
  public func assigned<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self?>, on object: Root) -> Self {
    object[keyPath: keyPath] = self
    return self
  }

  @inlinable
  @discardableResult
  public func performIfResponds(_ selector: Selector) -> Unmanaged<AnyObject>? {
    if responds(to: selector) {
      return perform(selector)
    }
    return nil
  }

  @inlinable
  @discardableResult
  public func performIfResponds(_ selector: Selector, with object: Any?) -> Unmanaged<AnyObject>? {
    if responds(to: selector) {
      return perform(selector, with: object)
    }
    return nil
  }

  @inlinable
  @discardableResult
  public func performIfResponds(_ selector: Selector, with object1: Any?, with object2: Any?) -> Unmanaged<AnyObject>? {
    if responds(to: selector) {
      return perform(selector, with: object1, with: object2)
    }
    return nil
  }
}

#if canImport(Foundation)

import Foundation

private var kObservationKey: Void?

extension _KeyValueCodingAndObserving where Self: NSObject {

  public var observations: [AnyHashable: NSKeyValueObservation] {
    get { return associatedValue(forKey: &kObservationKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &kObservationKey)}
  }

  @discardableResult
  public func addObservation<Value>(for keyPath: KeyPath<Self, Value>, options: NSKeyValueObservingOptions = [], changeHandler: @escaping (Self, NSKeyValueObservedChange<Value>) -> Void) -> NSKeyValueObservation {
    let observation = observe(keyPath, options: options, changeHandler: changeHandler)
    observations[keyPath] = observation
    return observation
  }
}

#endif

#endif
