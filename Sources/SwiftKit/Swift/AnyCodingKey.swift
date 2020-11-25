//
//  AnyCodingKey.swift
//
//  Created by Sereivoan Yong on 11/24/20.
//

public struct AnyCodingKey: CodingKey {
  
  public let stringValue: String
  
  public init?(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }
  
  public let intValue: Int?
  
  public init?(intValue: Int) {
    self.stringValue = String(intValue)
    self.intValue = intValue
  }
}

extension AnyCodingKey: ExpressibleByStringLiteral {
  
  public init(stringLiteral value: String) {
    self.stringValue = value
    self.intValue = nil
  }
}
