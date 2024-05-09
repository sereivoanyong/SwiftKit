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
}

#if canImport(Foundation)

import Foundation

extension KeyedDecodingContainerProtocol {

  @inlinable
  public func decode(by formatter: DateFormatter, forKey key: Key) throws -> Date {
    let string = try decode(String.self, forKey: key)
    guard let date = formatter.date(from: string) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Date string does not match format expected by formatter."))
    }
    return date
  }

  @inlinable
  public func decodeIfPresent(by formatter: DateFormatter, forKey key: Key) throws -> Date? {
    guard let string = try decodeIfPresent(String.self, forKey: key) else { return nil }
    guard let date = formatter.date(from: string) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Date string does not match format expected by formatter."))
    }
    return date
  }
}

extension SingleValueDecodingContainer {

  @inlinable
  public func decode(by formatter: DateFormatter) throws -> Date {
    let string = try decode(String.self)
    guard let date = formatter.date(from: string) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Date string does not match format expected by formatter."))
    }
    return date
  }
}

extension KeyedEncodingContainerProtocol {
  
  @inlinable
  public mutating func encode(_ value: Date, by formatter: DateFormatter, forKey key: Key) throws {
    try encode(formatter.string(from: value), forKey: key)
  }

  @inlinable
  public mutating func encodeIfPresent(_ value: Date?, by formatter: DateFormatter, forKey key: Key) throws {
    try encodeIfPresent(value.map(formatter.string(from:)), forKey: key)
  }
}

extension SingleValueEncodingContainer {

  @inlinable
  public mutating func encode(_ value: Date, by formatter: DateFormatter) throws {
    try encode(formatter.string(from: value))
  }
}

#endif
