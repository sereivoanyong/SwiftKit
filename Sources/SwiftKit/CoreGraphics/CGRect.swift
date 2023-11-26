//
//  CGRect.swift
//
//  Created by Sereivoan Yong on 8/2/17.
//

#if canImport(CoreGraphics)

import CoreGraphics

extension CGRect {

  public init(x: CGFloat, y: CGFloat, size: CGSize) {
    self.init(origin: CGPoint(x: x, y: y), size: size)
  }

  public init(origin: CGPoint, width: CGFloat, height: CGFloat) {
    self.init(origin: origin, size: CGSize(width: width, height: height))
  }

  public var x: CGFloat {
    @inlinable get { return origin.x }
    @inlinable mutating set { origin.x = newValue }
  }

  public var y: CGFloat {
    @inlinable get { return origin.y }
    @inlinable mutating set { origin.y = newValue }
  }

  public var center: CGPoint {
    return CGPoint(x: midX, y: midY)
  }

  /*
  public var width: CGFloat {
    @inlinable get { return size.width }
    @inlinable mutating set { size.width = newValue }
  }

  public var height: CGFloat {
    @inlinable get { return size.height }
    @inlinable mutating set { size.height = newValue }
  }
  */

  public func ratioThatFits(_ rect: CGRect) -> CGFloat {
    let ratio = rect.width / width
    if height * ratio <= rect.height {
      return ratio
    }
    return rect.height / height
  }

  public func rectThatFits(_ rect: CGRect) -> CGRect {
    let ratio = ratioThatFits(rect)
    let size = CGSize(width: ratio * width, height: ratio * height)
    let offset = CGPoint(x: (rect.width - size.width) / 2, y: (rect.height - size.height) / 2)
    return CGRect(origin: offset, size: size)
  }
}

#endif
