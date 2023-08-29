//
//  UIScreen.swift
//
//  Created by Sereivoan Yong on 2/4/23.
//

import UIKit

extension UIScreen {

  // The documentation mentions that 0 is a possible value, so we guard against this.
  // It's unclear whether values between 0 and 1 are possible, otherwise `max(scale, 1)` would
  // suffice.
  @inlinable
  public var nonZeroScale: CGFloat {
    let scale = scale
    return scale > 0 ? scale : 1
  }

  @inlinable
  public var pointPerPixel: CGFloat {
    return 1 / nonZeroScale
  }
}
