//
//  URLEncoding.swift
//
//  Created by Sereivoan Yong on 2/2/24.
//

import Foundation

@propertyWrapper
public struct URLEncoding: Equatable {

  public var wrappedValue: URL?

  public init(wrappedValue: URL?) {
    self.wrappedValue = wrappedValue
  }

  public init(string: String?) {
    guard let string = string?.addingPercentEncoding(withAllowedCharacters: .urlAllowed) else {
      wrappedValue = nil
      return
    }
    if #available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *) {
      wrappedValue = URL(string: string, encodingInvalidCharacters: false)
    } else {
      wrappedValue = URL(string: string)
    }
  }
}

extension URLEncoding: CustomStringConvertible {

  public var description: String {
    if let wrappedValue {
      return wrappedValue.description
    }
    return "nil"
  }
}

extension URLEncoding: CustomDebugStringConvertible {

  public var debugDescription: String {
    if let wrappedValue {
      return wrappedValue.debugDescription
    }
    return "nil"
  }
}

extension KeyedDecodingContainerProtocol {

  public func decode(_ type: URLEncoding.Type, forKey key: Key) throws -> URLEncoding {
    let string = try decodeIfPresent(String.self, forKey: key)
    return URLEncoding(string: string)
  }

  @inlinable
  public func decode(forKey key: Key) throws -> URLEncoding {
    return try decode(URLEncoding.self, forKey: key)
  }
}

extension KeyedEncodingContainerProtocol {

  public mutating func encode(_ value: URLEncoding, forKey key: Key) throws {
    try encodeIfPresent(value.wrappedValue, forKey: key)
  }
}

