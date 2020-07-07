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

extension KeyedDecodingContainerProtocol {
  
  @inlinable public func decode<T>(forKey key: Key) throws -> T where T: Decodable {
    return try decode(T.self, forKey: key)
  }
  
  @inlinable public func decodeIfPresent<T>(forKey key: Key) throws -> T? where T: Decodable {
    return try decodeIfPresent(T.self, forKey: key)
  }
}

extension SingleValueDecodingContainer {
  
  @inlinable public func decode<T>() throws -> T where T: Decodable {
    return try decode(T.self)
  }
  
  @inlinable public func decodeIfPresent<T>() throws -> T? where T: Decodable {
    return try decodeNil() ? decode(T.self) : nil
  }
}
