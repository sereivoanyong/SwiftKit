//
//  NSKeyValueObservation.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

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
