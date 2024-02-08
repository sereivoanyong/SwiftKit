//
//  StorageDataTransforming.swift
//
//  Created by Sereivoan Yong on 1/31/24.
//

#if canImport(Foundation)

import Foundation

public struct StorageDataTransforming<T> {

  public let value: (Data) throws -> T?
  public let data: (T) throws -> Data?

  public init(value: @escaping (Data) throws -> T?, data: @escaping (T) throws -> Data?) {
    self.value = value
    self.data = data
  }

  public func value(from data: Data) throws -> T? {
    return try value(data)
  }

  public func data(from value: T) throws -> Data? {
    return try data(value)
  }

  public static func encoding(_ encoding: String.Encoding) -> Self where T == String {
    return Self(
      value: { data in String(data: data, encoding: encoding) },
      data: { value in value.data(using: encoding) }
    )
  }

  public static func jsonSerializing(readingOptions: JSONSerialization.ReadingOptions = [], writingOptions: JSONSerialization.WritingOptions = []) -> Self {
    return Self(
      value: { data in try JSONSerialization.jsonObject(with: data, options: readingOptions) as? T },
      data: { value in try JSONSerialization.data(withJSONObject: value, options: writingOptions) }
    )
  }

  public static func jsonCoding(_ decoder: JSONDecoder = .init(), _ encoder: JSONEncoder = .init()) -> Self where T: Codable {
    return Self(
      value: { data in try decoder.decode(T.self, from: data) },
      data: { value in try encoder.encode(value) }
    )
  }

  public static func propertyListCoding(_ decoder: PropertyListDecoder = .init(), _ encoder: PropertyListEncoder = .init()) -> Self where T: Codable {
    return Self(
      value: { data in try decoder.decode(T.self, from: data) },
      data: { value in try encoder.encode(value) }
    )
  }

  public static func keyedArchiving(requiringSecureCoding: Bool = true) -> Self where T: NSObject & NSCoding {
    return Self(
      value: { data in try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data) },
      data: { value in try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: requiringSecureCoding) }
    )
  }
}

#endif
