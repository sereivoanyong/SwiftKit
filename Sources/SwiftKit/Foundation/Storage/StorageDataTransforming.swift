//
//  StorageDataTransforming.swift
//
//  Created by Sereivoan Yong on 1/31/24.
//

#if canImport(Foundation)

import Foundation

public protocol StorageDataTransforming<T> {

  associatedtype T

  func value(from data: Data) throws -> T?
  func data(from value: T) throws -> Data
}

// MARK: StorageCoding

public struct StorageCoding<T: Codable>: StorageDataTransforming {

  public let decoder: TopLevelDecoder
  public let encoder: TopLevelEncoder

  public init(_ decoder: TopLevelDecoder, _ encoder: TopLevelEncoder) {
    self.decoder = decoder
    self.encoder = encoder
  }

  public func value(from data: Data) throws -> T? {
    return try decoder.decode(T.self, from: data)
  }

  public func data(from value: T) throws -> Data {
    return try encoder.encode(value)
  }
}

extension StorageDataTransforming {

  public static func jsonCoding<T>(_ decoder: JSONDecoder = .init(), _ encoder: JSONEncoder = .init()) -> Self where Self == StorageCoding<T>, T: Codable {
    return Self(decoder, encoder)
  }

  public static func propertyListCoding<T>(_ decoder: PropertyListDecoder = .init(), _ encoder: PropertyListEncoder = .init()) -> Self where Self == StorageCoding<T>, T: Codable {
    return Self(decoder, encoder)
  }
}

// MARK: StorageKeyedArchiving

public struct StorageKeyedArchiving<T: NSObject & NSCoding>: StorageDataTransforming {

  public let requiringSecureCoding: Bool

  public init(requiringSecureCoding: Bool = true) {
    self.requiringSecureCoding = requiringSecureCoding
  }

  public func value(from data: Data) throws -> T? {
    return try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
  }

  public func data(from value: T) throws -> Data {
    return try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: requiringSecureCoding)
  }
}

extension StorageDataTransforming {

  public static func keyedArchiving<T>(requiringSecureCoding: Bool = true) -> Self where Self == StorageKeyedArchiving<T>, T: NSObject & NSCoding {
    return Self(requiringSecureCoding: requiringSecureCoding)
  }
}

// MARK: StorageJSONSerializating

public struct StorageJSONSerializating<T>: StorageDataTransforming {

  public let readingOptions: JSONSerialization.ReadingOptions
  public let writingOptions: JSONSerialization.WritingOptions

  public init(readingOptions: JSONSerialization.ReadingOptions = [], writingOptions: JSONSerialization.WritingOptions = []) {
    self.readingOptions = readingOptions
    self.writingOptions = writingOptions
  }

  public func value(from data: Data) throws -> T? {
    return try JSONSerialization.jsonObject(with: data, options: readingOptions) as? T
  }

  public func data(from value: T) throws -> Data {
    return try JSONSerialization.data(withJSONObject: value, options: writingOptions)
  }
}

extension StorageDataTransforming {

  public static func jsonSerializing<T>(readingOptions: JSONSerialization.ReadingOptions = [], writingOptions: JSONSerialization.WritingOptions = []) -> Self where Self == StorageJSONSerializating<T> {
    return Self(readingOptions: readingOptions, writingOptions: writingOptions)
  }
}

#endif
