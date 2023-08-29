//
//  CGFloat.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import CoreGraphics

extension CGFloat {

  /// Ceils `self` so that it's aligned on a pixel boundary with the provided scale.
  @inlinable
  public func ceiledToPixel(scale: CGFloat) -> CGFloat {
    return Darwin.ceil(self * scale) / scale
  }

  /// Floors `self` so that it's aligned on a pixel boundary with the provided scale.
  @inlinable
  public func flooredToPixel(scale: CGFloat) -> CGFloat {
    return Darwin.floor(self * scale) / scale
  }

  /// Rounds `self` so that it's aligned on a pixel boundary with the provided scale.
  @inlinable
  public func roundedToPixel(scale: CGFloat) -> CGFloat {
    return Darwin.round(self * scale) / scale
  }

  /// Ceils `self` so that it's aligned on a pixel boundary with the provided scale.
  @inlinable
  public mutating func ceilToPixel(scale: CGFloat) {
    self = ceiledToPixel(scale: scale)
  }

  /// Floors `self` so that it's aligned on a pixel boundary with the provided scale.
  @inlinable
  public mutating func floorToPixel(scale: CGFloat) {
    self = flooredToPixel(scale: scale)
  }

  /// Rounds `self` so that it's aligned on a pixel boundary with the provided scale.
  @inlinable
  public mutating func roundToPixel(scale: CGFloat) {
    self = roundedToPixel(scale: scale)
  }
}
