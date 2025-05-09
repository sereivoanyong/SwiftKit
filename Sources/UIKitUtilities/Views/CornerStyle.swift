//
//  CornerStyle.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 5/9/25.
//

import CoreGraphics

public enum CornerStyle {

  case fixed(CGFloat)
  case fractional(CGFloat)

  public static var capsule: Self {
    return .fractional(0.5)
  }

  public var isCapsule: Bool {
    if case .fractional(let fraction) = self, fraction == 0.5 {
      return true
    }
    return false
  }

  public func resolvedRadius(with rect: CGRect) -> CGFloat {
    switch self {
    case .fixed(let radius):
      return radius
    case .fractional(let fraction):
      return min(rect.width, rect.height) * fraction
    }
  }
}
