//
//  Axis.swift
//
//  Created by Sereivoan Yong on 10/26/22.
//

import UIKit

public struct Axis: OptionSet {

  public let rawValue: UInt

  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }

  public static let horizontal: Self = Self(rawValue: 1 << 0)

  public static let vertical: Self = Self(rawValue: 1 << 1)

  public static let both: Self = [horizontal, vertical]
}
