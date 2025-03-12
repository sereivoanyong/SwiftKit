//
//  Reference.swift
//
//  Created by Sereivoan Yong on 10/29/17.
//

import Foundation

public protocol ReferenceProtocol<T>: AnyObject {

  associatedtype T

  var base: T? { get set }

  init(_ base: T)
}

// For weakly holding object
final public class WeakReference: ReferenceProtocol {

  weak public var base: AnyObject?

  public init(_ base: AnyObject) {
    self.base = base
  }
}

// For holding value
final public class Reference<T>: ReferenceProtocol {

  public var base: T?

  public init(_ base: T) {
    self.base = base
  }
}

// For holding any value
public typealias AnyReference = Reference<Any>

/*
extension _ObjectiveCBridgeable where _ObjectiveCType: ReferenceProtocol<Self> {

  public func _bridgeToObjectiveC() -> _ObjectiveCType {
    return .init(self)
  }

  public static func _forceBridgeFromObjectiveC(_ source: _ObjectiveCType, result: inout Self?) {
    if !_conditionallyBridgeFromObjectiveC(source, result: &result) {
      fatalError("Unable to bridge \(_ObjectiveCType.self) to \(self)")
    }
  }

  public static func _conditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType, result: inout Self?) -> Bool {
    result = source.base
    return true
  }

  @_effects(readonly)
  public static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> Self {
    var result: Self?
    _forceBridgeFromObjectiveC(source!, result: &result)
    return result!
  }
}
 */
