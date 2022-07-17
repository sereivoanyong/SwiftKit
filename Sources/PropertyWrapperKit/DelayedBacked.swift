//
//  DelayedBacked.swift
//
//  Created by Sereivoan Yong on 4/6/22.
//

import Foundation

@propertyWrapper
public struct DelayedBacked<Value, Wrapped> {

  public var value: Value!

  public init() {
  }

  public var wrappedValue: Wrapped {
    get {
      guard let value = value else {
        fatalError("property accessed before being initialized")
      }
      return value as! Wrapped
    }
    set {
      value = newValue as? Value
    }
  }

  public var projectedValue: Value {
    get { return value }
    set { value = newValue }
  }
}
