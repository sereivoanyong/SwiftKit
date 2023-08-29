//
//  TopLevelDecoder.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

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

extension JSONDecoder: TopLevelDecoder { }

extension PropertyListDecoder: TopLevelDecoder { }

extension TopLevelDecoder where Self == JSONDecoder {

  public static func json() -> Self {
    return JSONDecoder()
  }
}

extension TopLevelDecoder where Self == PropertyListDecoder {

  public static func propertyList() -> Self {
    return PropertyListDecoder()
  }
}
