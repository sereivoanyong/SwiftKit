//
//  TopLevelEncoder.swift
//
//  Created by Sereivoan Yong on 12/15/22.
//

#if canImport(Foundation)

import Foundation

public protocol TopLevelEncoder: AnyObject {

  func encode<T: Encodable>(_ value: T) throws -> Data
}

// MARK: JSONEncoder

extension JSONEncoder: TopLevelEncoder { }

extension TopLevelEncoder {

  public static func json() -> Self where Self == JSONEncoder {
    return JSONEncoder()
  }
}

// MARK: PropertyListEncoder

extension PropertyListEncoder: TopLevelEncoder { }

extension TopLevelEncoder {

  public static func propertyList() -> Self where Self == PropertyListEncoder {
    return PropertyListEncoder()
  }
}

#endif
