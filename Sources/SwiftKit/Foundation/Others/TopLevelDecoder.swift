//
//  TopLevelDecoder.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

#if canImport(Foundation)

import Foundation

public protocol TopLevelDecoder: AnyObject {
  
  func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension TopLevelDecoder {
  
  @inlinable
  public func decode<T: Decodable>(from data: Data) throws -> T {
    return try decode(T.self, from: data)
  }

  @inlinable
  public func decodeFile<T: Decodable>(name: String, extension: String = "json", in bundle: Bundle = .main) throws -> T {
    let url = bundle.url(forResource: name, withExtension: `extension`)!
    return try decode(T.self, from: Data(contentsOf: url))
  }
}

// MARK: JSONDecoder

extension JSONDecoder: TopLevelDecoder { }

extension TopLevelDecoder {

  public static func json() -> Self where Self == JSONDecoder {
    return JSONDecoder()
  }
}

// MARK: PropertyListDecoder

extension PropertyListDecoder: TopLevelDecoder { }

extension TopLevelDecoder {

  public static func propertyList() -> Self where Self == PropertyListDecoder {
    return PropertyListDecoder()
  }
}

#endif
