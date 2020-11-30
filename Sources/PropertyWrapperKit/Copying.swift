//
//  Copying.swift
//
//  Created by Sereivoan Yong on 11/30/20.
//

import Foundation

@propertyWrapper public struct Copying<Value: NSCopying> {
  
  private var _value: Value
  
  public init(wrappedValue value: Value) {
    _value = value.copy() as! Value
  }
  
  public var wrappedValue: Value {
    get { return _value }
    set { _value = newValue.copy() as! Value }
  }
}
