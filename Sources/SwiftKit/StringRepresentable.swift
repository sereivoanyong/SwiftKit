//
//  StringRepresentable.swift
//
//  Created by Sereivoan Yong on 10/24/23.
//

import Foundation

public protocol StringRepresentable: Hashable, ExpressibleByStringLiteral {

  var string: String { get }

  init(_ string: String)
}

extension StringRepresentable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.string == rhs.string
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(string)
  }

  public init(stringLiteral value: String) {
    self.init(value)
  }
}

extension StringRepresentable where Self: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    self.init(string)
  }
}

extension StringRepresentable where Self: Encodable {

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(string)
  }
}
