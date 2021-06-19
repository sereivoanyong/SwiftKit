//
//  UIEdgeInsets.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UIEdgeInsets {
  
  public init(inset: CGFloat) {
    self.init(top: inset, left: inset, bottom: inset, right: inset)
  }
  
  public init(left: CGFloat, right: CGFloat) {
    self.init(top: 0, left: left, bottom: 0, right: right)
  }
  
  public init(top: CGFloat, bottom: CGFloat) {
    self.init(top: top, left: 0, bottom: bottom, right: 0)
  }
  
  @inlinable
  public var horizontal: CGFloat {
    left + right
  }
  
  @inlinable
  public var vertical: CGFloat {
    top + bottom
  }
  
  @inlinable
  public var withoutHorizontal: UIEdgeInsets {
    withHorizontal(left: 0, right: 0)
  }
  
  @inlinable
  public var withoutVertical: UIEdgeInsets {
    withVertical(top: 0, bottom: 0)
  }
  
  @inlinable
  public func withHorizontal(left: CGFloat, right: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
  
  @inlinable
  public func withVertical(top: CGFloat, bottom: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
}

extension UIEdgeInsets: AdditiveArithmetic {

  public static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
  }

  public static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
  }
}
#endif
