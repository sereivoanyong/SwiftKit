//
//  StringInitializable.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/10/26.
//

public protocol StringInitializable {

  init?(_ text: String)
}

extension Int: StringInitializable { }
extension Float: StringInitializable { }
extension Double: StringInitializable { }

#if canImport(Foundation)

import Foundation

extension Decimal: StringInitializable {

  public init?(_ text: String) {
    self.init(string: text)
  }
}

#endif
