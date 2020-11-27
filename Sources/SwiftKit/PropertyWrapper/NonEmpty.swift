//
//  NonEmpty.swift
//
//  Created by Sereivoan Yong on 11/27/20.
//

import Foundation

/// This wrapper treats empty collection as nil which makes empty and nil collections equal and have the same hashValue.
@propertyWrapper public struct NonEmpty<Collection: Swift.Collection> {
  
  public var wrappedValue: Collection?
  
  public init(wrappedValue: Collection?) {
    self.wrappedValue = wrappedValue
  }
}

extension NonEmpty: Decodable where Collection: Decodable {
  
  public init(from decoder: Decoder) throws {
    wrappedValue = try Collection(from: decoder)
  }
}

extension NonEmpty: Encodable where Collection: Encodable {
  
  public func encode(to encoder: Encoder) throws {
    try wrappedValue?.encode(to: encoder)
  }
}

extension NonEmpty: Equatable where Collection: Equatable {
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs.wrappedValue, rhs.wrappedValue) {
    case (.some(let lhs), .some(let rhs)):
      return lhs == rhs
    case (.some(let lhs), .none):
      return lhs.isEmpty
    case (.none, .some(let rhs)):
      return rhs.isEmpty
    case (.none, .none):
      return true
    }
  }
}

extension NonEmpty: Hashable where Collection: Hashable {
  
  public func hash(into hasher: inout Hasher) {
    switch wrappedValue {
    case .some(let collection):
      hasher.combine(collection.isEmpty ? nil as Collection? : collection)
    case .none:
      hasher.combine(nil as Collection?)
    }
  }
}
