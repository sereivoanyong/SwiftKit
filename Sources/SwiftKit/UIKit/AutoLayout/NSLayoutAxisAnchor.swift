//
//  NSLayoutAxisAnchor.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

import UIKit

public struct _AxisEdgeAttributes<Anchor> {

  public let anchor: Anchor
  public let constant: CGFloat

  @usableFromInline
  init(anchor: Anchor, constant: CGFloat) {
    self.anchor = anchor
    self.constant = constant
  }
}

/* This does not work
@inlinable
public func == <AnchorType>(anchor: NSLayoutAnchor<AnchorType>, otherAnchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint where AnchorType: AnyObject {
  anchor.constraint(equalTo: otherAnchor)
}
*/

extension NSLayoutXAxisAnchor {

  /// `anchor == otherAnchor`
  /// - returns: `anchor.constraint(equalTo: otherAnchor)`
  @inlinable
  public static func == (anchor: NSLayoutXAxisAnchor, otherAnchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return anchor.constraint(equalTo: otherAnchor)
  }

  /// `anchor >= otherAnchor`
  /// - returns: `anchor.constraint(greaterThanOrEqualTo: otherAnchor)`
  @inlinable
  public static func >= (anchor: NSLayoutXAxisAnchor, otherAnchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return anchor.constraint(greaterThanOrEqualTo: otherAnchor)
  }

  /// `anchor <= otherAnchor`
  /// - returns: `anchor.constraint(lessThanOrEqualTo: otherAnchor)`
  @inlinable
  public static func <= (anchor: NSLayoutXAxisAnchor, otherAnchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return anchor.constraint(lessThanOrEqualTo: otherAnchor)
  }

  /// `anchor == otherAnchor + constant`
  /// - returns: `anchor.constraint(equalTo: otherAnchor, constant: constant)`
  @inlinable
  public static func == (anchor: NSLayoutXAxisAnchor, attributes: _AxisEdgeAttributes<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return anchor.constraint(equalTo: attributes.anchor, constant: attributes.constant)
  }

  /// `anchor >= otherAnchor + constant`
  /// - returns: `anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)`
  @inlinable
  public static func >= (anchor: NSLayoutXAxisAnchor, attributes: _AxisEdgeAttributes<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return anchor.constraint(greaterThanOrEqualTo: attributes.anchor, constant: attributes.constant)
  }

  /// `anchor <= otherAnchor + constant`
  /// - returns: `anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant)`
  @inlinable
  public static func <= (anchor: NSLayoutXAxisAnchor, attributes: _AxisEdgeAttributes<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
    return anchor.constraint(lessThanOrEqualTo: attributes.anchor, constant: attributes.constant)
  }

  @inlinable
  public static func + (anchor: NSLayoutXAxisAnchor, constant: CGFloat) -> _AxisEdgeAttributes<NSLayoutXAxisAnchor> {
    return _AxisEdgeAttributes(anchor: anchor, constant: constant)
  }

  @inlinable
  public static func - (anchor: NSLayoutXAxisAnchor, constant: CGFloat) -> _AxisEdgeAttributes<NSLayoutXAxisAnchor> {
    return _AxisEdgeAttributes(anchor: anchor, constant: -constant)
  }
}

extension NSLayoutYAxisAnchor {

  /// `anchor == otherAnchor`
  /// - returns: `anchor.constraint(equalTo: otherAnchor)`
  @inlinable
  public static func == (anchor: NSLayoutYAxisAnchor, otherAnchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    anchor.constraint(equalTo: otherAnchor)
  }

  /// `anchor >= otherAnchor`
  /// - returns: `anchor.constraint(greaterThanOrEqualTo: otherAnchor)`
  @inlinable
  public static func >= (anchor: NSLayoutYAxisAnchor, otherAnchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return anchor.constraint(greaterThanOrEqualTo: otherAnchor)
  }

  /// `anchor <= otherAnchor`
  /// - returns: `anchor.constraint(lessThanOrEqualTo: otherAnchor)`
  @inlinable
  public static func <= (anchor: NSLayoutYAxisAnchor, otherAnchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return anchor.constraint(lessThanOrEqualTo: otherAnchor)
  }

  /// `anchor == otherAnchor + constant`
  /// - returns: `anchor.constraint(equalTo: otherAnchor, constant: constant)`
  @inlinable
  public static func == (anchor: NSLayoutYAxisAnchor, attributes: _AxisEdgeAttributes<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return anchor.constraint(equalTo: attributes.anchor, constant: attributes.constant)
  }

  /// `anchor >= otherAnchor + constant`
  /// - returns: `anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)`
  @inlinable
  public static func >= (anchor: NSLayoutYAxisAnchor, attributes: _AxisEdgeAttributes<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return anchor.constraint(greaterThanOrEqualTo: attributes.anchor, constant: attributes.constant)
  }

  /// `anchor <= otherAnchor + constant`
  /// - returns: `anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant)`
  @inlinable
  public static func <= (anchor: NSLayoutYAxisAnchor, attributes: _AxisEdgeAttributes<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
    return anchor.constraint(lessThanOrEqualTo: attributes.anchor, constant: attributes.constant)
  }

  @inlinable
  public static func + (anchor: NSLayoutYAxisAnchor, constant: CGFloat) -> _AxisEdgeAttributes<NSLayoutYAxisAnchor> {
    return _AxisEdgeAttributes(anchor: anchor, constant: constant)
  }

  @inlinable
  public static func - (anchor: NSLayoutYAxisAnchor, constant: CGFloat) -> _AxisEdgeAttributes<NSLayoutYAxisAnchor> {
    return _AxisEdgeAttributes(anchor: anchor, constant: -constant)
  }
}
