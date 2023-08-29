//
//  UITraitCollection.swift
//
//  Created by Sereivoan Yong on 2/4/23.
//

import UIKit

extension UITraitCollection {

  // The documentation mentions that 0 is a possible value, so we guard against this.
  // It's unclear whether values between 0 and 1 are possible, otherwise `max(scale, 1)` would
  // suffice.
  @inlinable
  public var nonZeroDisplayScale: CGFloat {
    let displayScale = displayScale
    return displayScale > 0 ? displayScale : 1
  }

  @inlinable
  public var displayPointPerPixel: CGFloat {
    return 1 / nonZeroDisplayScale
  }
}
