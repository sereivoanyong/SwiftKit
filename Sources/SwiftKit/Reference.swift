//
//  Reference.swift
//
//  Created by Sereivoan Yong on 10/29/17.
//

public protocol ReferenceProtocol<T>: AnyObject {

  associatedtype T

  var value: T { get }

  init(_ value: T)
}

final public class Reference<T>: ReferenceProtocol {

  public var value: T
  
  public init(_ value: T) {
    self.value = value
  }
}

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
    result = source.value
    return true
  }

  @_effects(readonly)
  public static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> Self {
    var result: Self?
    _forceBridgeFromObjectiveC(source!, result: &result)
    return result!
  }
}
