//
//  DelayedMutable.swift
//
//  Created by Sereivoan Yong on 12/17/22.
//

@propertyWrapper
public struct DelayedMutable<Value> {

  private var _value: Value?

  public var wrappedValue: Value {
    get {
      guard let value = _value else {
        fatalError("property accessed before being initialized")
      }
      return value
    }
    set {
      _value = newValue
    }
  }

  public init() {

  }

  mutating func reset() {
    _value = nil
  }
}
