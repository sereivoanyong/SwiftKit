//
//  NeverEmpty.swift
//
//  Created by Sereivoan Yong on 11/29/20.
//

@propertyWrapper
public struct NeverEmpty<Collection: Swift.Collection> {
  
  private var _value: Collection?
  
  public init(wrappedValue: Collection?) {
    self.wrappedValue = wrappedValue
  }
  
  public var wrappedValue: Collection? {
    get { return _value }
    set {
      if let newValue {
        _value = newValue.isEmpty ? nil : newValue
      } else {
        _value = nil
      }
    }
  }
}

extension NeverEmpty: Equatable where Collection: Equatable { }
