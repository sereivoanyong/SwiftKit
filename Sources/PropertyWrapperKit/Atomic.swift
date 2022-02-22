//
//  Atomic.swift
//
//  Created by Sereivoan Yong on 11/30/20.
//

import Foundation

@propertyWrapper
public struct Atomic<Value> {
  
  private var _value: Value
  private let lock = NSLock()
  
  public init(wrappedValue value: Value) {
    _value = value
  }
  
  public var wrappedValue: Value {
    get { return load() }
    set { store(newValue: newValue) }
  }
  
  private func load() -> Value {
    let value: Value
    lock.lock()
    value = _value
    lock.unlock()
    return value
  }
  
  private mutating func store(newValue: Value) {
    lock.lock()
    _value = newValue
    lock.unlock()
  }
}
