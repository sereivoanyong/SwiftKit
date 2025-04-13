//
//  SYCompatibility.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/13/25.
//

import Foundation

@_marker public protocol SYCompatible: AnyObject {}

extension SYCompatible {

  @inlinable
  public var sy: SYCompatibility<Self> {
    .init(self)
  }
}

public struct SYCompatibility<Base: SYCompatible> {

  public let base: Base

  @usableFromInline
  init(_ base: Base) {
    self.base = base
  }
}
