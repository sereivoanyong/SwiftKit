//
//  Misc.swift
//
//  Created by Sereivoan Yong on 11/24/20.
//

extension KeyedDecodingContainerProtocol {
  
  @inlinable 
  public func decode<T: Decodable>(forKey key: Key) throws -> T {
    return try decode(T.self, forKey: key)
  }
  
  @inlinable 
  public func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
    return try decodeIfPresent(T.self, forKey: key)
  }
}

extension SingleValueDecodingContainer {
  
  @inlinable 
  public func decode<T: Decodable>() throws -> T {
    return try decode(T.self)
  }
  
  @inlinable 
  public func decodeIfPresent<T: Decodable>() throws -> T? {
    return try decodeNil() ? decode(T.self) : nil
  }
}
