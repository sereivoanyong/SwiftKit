//
//  StringRepresentable.swift
//
//  Created by Sereivoan Yong on 10/24/23.
//

import Foundation

public protocol StringRepresentable: RawRepresentable, Hashable, Sendable, ExpressibleByStringLiteral where RawValue == String, StringLiteralType == String {

  init(_ rawValue: RawValue)

  init(rawValue: RawValue)
}

extension StringRepresentable {

  public init(rawValue: RawValue) {
    self.init(rawValue)
  }

  // MARK: ExpressibleByStringLiteral

  public init(stringLiteral value: StringLiteralType) {
    self.init(value)
  }
}

extension StringRepresentable where Self: CustomStringConvertible {

  public var description: String {
    return rawValue
  }
}
