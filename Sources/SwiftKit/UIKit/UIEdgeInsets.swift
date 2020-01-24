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
  
  @inlinable public var horizontal: CGFloat {
    return left + right
  }
  
  @inlinable public var vertical: CGFloat {
    return top + bottom
  }
  
  @inlinable public var withoutHorizontal: UIEdgeInsets {
    return withHorizontal(left: 0, right: 0)
  }
  
  @inlinable public var withoutVertical: UIEdgeInsets {
    return withVertical(top: 0, bottom: 0)
  }
  
  @inlinable public func withHorizontal(left: CGFloat, right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
  
  @inlinable public func withVertical(top: CGFloat, bottom: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
  
  public static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
  }
  
  public static func += (_ lhs: inout UIEdgeInsets, _ rhs: UIEdgeInsets) {
    lhs = lhs + rhs
  }
}
#endif
