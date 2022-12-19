//
//  DelayedBacked.swift
//
//  Created by Sereivoan Yong on 4/6/22.
//

@propertyWrapper
public struct DelayedBacked<Value, Wrapped> {

  private var _value: Value!

  public var wrappedValue: Wrapped {
    get {
      guard let value = _value else {
        fatalError("property accessed before being initialized")
      }
      return value as! Wrapped
    }
    set {
      _value = newValue as? Value
    }
  }

  public var projectedValue: Value {
    get { return _value }
    set { _value = newValue }
  }

  public init() {
    
  }
}
