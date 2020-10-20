//
//  NSObject.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(ObjectiveC)
import ObjectiveC

extension NSObjectProtocol where Self: NSObject {
  
  @inlinable public func valueIfResponds(forKey key: String) -> Any? {
    if responds(to: Selector(key)) {
      return value(forKey: key)
    }
    return nil
  }
  
  @inlinable public func setValueIfResponds(_ value: Any?, forKey key: String) {
    if responds(to: Selector(key)) {
      setValue(value, forKey: key)
    }
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
