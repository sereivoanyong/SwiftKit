//
//  TopLevelEncoder.swift
//
//  Created by Sereivoan Yong on 12/15/22.
//

import Foundation

public protocol TopLevelEncoder: AnyObject {

  func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: TopLevelEncoder { }

extension PropertyListEncoder: TopLevelEncoder { }

extension TopLevelEncoder where Self == JSONEncoder {

  public static func json() -> Self {
    return JSONEncoder()
  }
}

extension TopLevelEncoder where Self == PropertyListEncoder {

  public static func propertyList() -> Self {
    return PropertyListEncoder()
  }
}
