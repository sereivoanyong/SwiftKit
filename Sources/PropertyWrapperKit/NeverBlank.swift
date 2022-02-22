//
//  NeverBlank.swift
//
//  Created by Sereivoan Yong on 11/29/20.
//

import SwiftKit

@propertyWrapper
public struct NeverBlank: Equatable {
  
  private var _value: String?
  
  public init(wrappedValue: String?) {
    self.wrappedValue = wrappedValue
  }
  
  public var wrappedValue: String? {
    get { return _value }
    set {
      if let newValue = newValue {
        _value = newValue.isBlank ? nil : newValue
      } else {
        _value = nil
      }
    }
  }
}

extension NeverBlank: CustomStringConvertible {
  
  public var description: String {
    return wrappedValue ?? "nil"
  }
}

extension NeverBlank: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    return "NeverBlank(" + (wrappedValue ?? "nil") + ")"
  }
}

extension NeverBlank: CustomReflectable {
  
  public var customMirror: Mirror {
    return Mirror(self, children: ["value": wrappedValue ?? "nil"])
  }
}

extension NeverBlank: Decodable {
  
  public init(from decoder: Decoder) throws {
    wrappedValue = try String(from: decoder)
  }
}

extension NeverBlank: Encodable {
  
  public func encode(to encoder: Encoder) throws {
    try wrappedValue?.encode(to: encoder)
  }
}
