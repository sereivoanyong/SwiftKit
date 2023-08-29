//
//  NSLayoutAnchor.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

import UIKit

@objc extension NSLayoutAnchor {
  
  @discardableResult
  final public func equalTo(_ anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c = constraint(equalTo: anchor, constant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
  
  @discardableResult
  final public func greaterThanOrEqualTo(_ anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c = constraint(greaterThanOrEqualTo: anchor, constant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
  
  @discardableResult
  final public func lessThanOrEqualTo(_ anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c = constraint(lessThanOrEqualTo: anchor, constant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
}

extension NSLayoutDimension {
  
  @discardableResult
  final public func equalTo(constant: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c = constraint(equalToConstant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
  
  @discardableResult
  final public func greaterThanOrEqualTo(constant: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c =  constraint(equalToConstant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
  
  @discardableResult
  final public func lessThanOrEqualTo(constant: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c =  constraint(lessThanOrEqualToConstant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
  
  @discardableResult
  final public func equalTo(_ anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c =  constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
  
  @discardableResult
  final public func greaterThanOrEqualTo(_ anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c =  constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
  
  @discardableResult
  final public func lessThanOrEqualTo(_ anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
    let c =  constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
    c.priority = priority
    c.isActive = true
    return c
  }
}
