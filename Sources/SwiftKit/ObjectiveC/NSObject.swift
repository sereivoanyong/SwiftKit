//
//  NSObject.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(ObjectiveC)
import ObjectiveC

extension NSObjectProtocol {
  
  public func assigned(to object: inout Self?) -> Self {
    object = self
    return self
  }
  
  public func assigned<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self?>, on object: Root) -> Self {
    object[keyPath: keyPath] = self
    return self
  }
  
  @inlinable public func valueIfResponds(forKey key: String) -> Any? {
    if responds(to: Selector(key)) {
      return (self as! NSObject).value(forKey: key)
    }
    return nil
  }
  
  @inlinable public func setValueIfResponds(_ value: Any?, forKey key: String) {
    if responds(to: Selector(key)) {
      (self as! NSObject).setValue(value, forKey: key)
    }
  }
  
  @discardableResult
  @inlinable public func performIfResponds(_ selector: Selector) -> Unmanaged<AnyObject>? {
    if responds(to: selector) {
      return perform(selector)
    }
    return nil
  }
  
  @discardableResult
  @inlinable public func performIfResponds(_ selector: Selector, with object: Any?) -> Unmanaged<AnyObject>? {
    if responds(to: selector) {
      return perform(selector, with: object)
    }
    return nil
  }
  
  @discardableResult
  @inlinable public func configure(_ handler: (Self) -> Void) -> Self {
    handler(self)
    return self
  }
  
  public func first(where predicate: (Self) throws -> Bool, next: (Self) throws -> Self?) rethrows -> Self? {
    var currentTarget: Self? = self
    while let target = currentTarget {
      if try predicate(target) {
        return target
      }
      currentTarget = try next(target)
    }
    return nil
  }
}

#if canImport(Foundation)
import Foundation

@available(iOS 11.0, *)
private var kObservationKey: Void?

extension NSObjectProtocol where Self: NSObject {
  
  @available(iOS 11.0, *)
  public var observations: [AnyHashable: NSKeyValueObservation] {
    get { return associatedValue(forKey: &kObservationKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &kObservationKey)}
  }
  
  @discardableResult
  @available(iOS 11.0, *)
  public func addObservation<Value>(for keyPath: KeyPath<Self, Value>, options: NSKeyValueObservingOptions = [], changeHandler: @escaping (Self, NSKeyValueObservedChange<Value>) -> Void) -> NSKeyValueObservation {
    let observation = observe(keyPath, options: options, changeHandler: changeHandler)
    observations[keyPath] = observation
    return observation
  }
}
#endif
#endif
