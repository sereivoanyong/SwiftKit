//
//  CGSize.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(CoreGraphics)
import CoreGraphics

extension CGSize {
  
  /// Creates a size with the same dimension
  @inlinable public init(dimension: CGFloat) {
    self.init(width: dimension, height: dimension)
  }
  
  @inlinable public var maxDimension: CGFloat {
    return max(width, height)
  }
  
  @inlinable public var minDimension: CGFloat {
    return min(width, height)
  }
  
  public func aspectFit(to boundingSize: CGSize) -> CGSize {
    let minRatio = min(boundingSize.width / width, boundingSize.height / height)
    return CGSize(width: width * minRatio, height: height * minRatio)
  }
  
  public func aspectFill(to boundingSize: CGSize) -> CGSize {
    let minRatio = max(boundingSize.width / width, boundingSize.height / height)
    let aWidth = min(width * minRatio, boundingSize.width)
    let aHeight = min(height * minRatio, boundingSize.height)
    return CGSize(width: aWidth, height: aHeight)
  }
  
  public static var greatestFiniteMagnitude: CGSize {
    return CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
  }
  
  public static var leastNormalMagnitude: CGSize {
    return CGSize(width: CGFloat.leastNormalMagnitude, height: .leastNormalMagnitude)
  }
  
  public static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
  
  public static func += (lhs: inout CGSize, rhs: CGSize) {
    lhs = lhs + rhs
  }
  
  public static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
  }
  
  public static func -= (lhs: inout CGSize, rhs: CGSize) {
    lhs = lhs - rhs
  }
  
  public static func * (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width * scalar, height: size.height * scalar)
  }
  
  public static func *= (lhs: inout CGSize, scalar: CGFloat) {
    lhs = lhs * scalar
  }
  
  public static func / (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width / scalar, height: size.height / scalar)
  }
  
  public static func /= (lhs: inout CGSize, scalar: CGFloat) {
    lhs = lhs / scalar
  }
}
#endif
