//
//  Delayed.swift
//
//  Created by Sereivoan Yong on 2/9/22.
//

@propertyWrapper
public struct Delayed<Value> {

  private var _value: Value?

  public var wrappedValue: Value {
    get {
      guard let value = _value else {
        fatalError("property accessed before being initialized")
      }
      return value
    }
    set {
      precondition(_value != nil, "property initialized twice")
      _value = newValue
    }
  }

  public init() {

  }
}
