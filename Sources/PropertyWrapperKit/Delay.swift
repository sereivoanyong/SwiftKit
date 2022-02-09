//
//  Delay.swift
//
//  Created by Sereivoan Yong on 2/9/22.
//

import Foundation

@propertyWrapper public struct DelayedMutable<Value> {

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

@propertyWrapper public struct DelayedImmutable<Value> {

  private var _value: Value? = nil

  public var wrappedValue: Value {
    get {
      guard let value = _value else {
        fatalError("property accessed before being initialized")
      }
      return value
    }
    set {
      if _value != nil {
        fatalError("property initialized twice")
      }
      _value = newValue
    }
  }

  public init() {

  }
}
