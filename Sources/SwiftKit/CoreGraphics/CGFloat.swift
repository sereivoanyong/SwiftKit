//
//  CGFloat.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(CoreGraphics) && canImport(UIKit)
import CoreGraphics
import UIKit

extension CGFloat {
  
  public static let screenScale: CGFloat = UIScreen.main.scale
  public static let pixel: CGFloat = 1 / screenScale
  
  @inlinable public mutating func ceilToPixel() {
    self = ceiled(by: .screenScale)
  }
  
  @inlinable public mutating func floorToPixel() {
    self = floored(by: .screenScale)
  }
  
  @inlinable public mutating func roundToPixel() {
    self = rounded(by: .screenScale)
  }
  
  @inlinable public var ceiledToPixel: CGFloat {
    return ceiled(by: .screenScale)
  }
  
  @inlinable public var flooredToPixel: CGFloat {
    return floored(by: .screenScale)
  }
  
  @inlinable public var roundedToPixel: CGFloat {
    return rounded(by: .screenScale)
  }
}
#endif
