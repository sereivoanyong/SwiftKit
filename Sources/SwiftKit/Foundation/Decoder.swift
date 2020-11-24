//
//  Decoder.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

#if canImport(Foundation)
import Foundation

public protocol _TopLevelDecoder: AnyObject {
  
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension _TopLevelDecoder {
  
  @inlinable public func decode<T>(from data: Data) throws -> T where T: Decodable {
    return try decode(T.self, from: data)
  }
  
  @inlinable public func decodeFile<T>(name: String, extension: String = "json", in bundle: Bundle = .main) throws -> T where T: Decodable {
    let url = bundle.url(forResource: name, withExtension: `extension`)!
    return try decode(T.self, from: Data(contentsOf: url))
  }
}

extension JSONDecoder: _TopLevelDecoder { }
extension PropertyListDecoder: _TopLevelDecoder { }
#endif
