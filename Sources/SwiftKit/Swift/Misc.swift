//
//  Misc.swift
//
//  Created by Sereivoan Yong on 11/24/20.
//

extension KeyedDecodingContainerProtocol {
  
  @inlinable 
  public func decode<T>(forKey key: Key) throws -> T where T: Decodable {
    return try decode(T.self, forKey: key)
  }
  
  @inlinable 
  public func decodeIfPresent<T>(forKey key: Key) throws -> T? where T: Decodable {
    return try decodeIfPresent(T.self, forKey: key)
  }
}

extension SingleValueDecodingContainer {
  
  @inlinable 
  public func decode<T>() throws -> T where T: Decodable {
    return try decode(T.self)
  }
  
  @inlinable 
  public func decodeIfPresent<T>() throws -> T? where T: Decodable {
    return try decodeNil() ? decode(T.self) : nil
  }
}
