//
//  NSLayoutDimension.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

import UIKit

public struct _DimensionAttributes {

  public let otherDimension: NSLayoutDimension
  public let multiplier: CGFloat

  @usableFromInline
  init(otherDimension: NSLayoutDimension, multiplier: CGFloat) {
    self.otherDimension = otherDimension
    self.multiplier = multiplier
  }
}

extension NSLayoutDimension {

  /// `anchor == otherAnchor`
  /// - returns: `anchor.constraint(equalTo: otherAnchor)`
  @inlinable
  public static func == (dimension: NSLayoutDimension, otherDimension: NSLayoutDimension) -> NSLayoutConstraint {
    return dimension.constraint(equalTo: otherDimension)
  }

  /// `anchor >= otherAnchor`
  /// - returns: `anchor.constraint(greaterThanOrEqualTo: otherAnchor)`
  @inlinable
  public static func >= (dimension: NSLayoutDimension, otherDimension: NSLayoutDimension) -> NSLayoutConstraint {
    return dimension.constraint(greaterThanOrEqualTo: otherDimension)
  }

  /// `anchor <= otherAnchor`
  /// - returns: `anchor.constraint(lessThanOrEqualTo: otherAnchor)`
  @inlinable
  public static func <= (dimension: NSLayoutDimension, otherDimension: NSLayoutDimension) -> NSLayoutConstraint {
    return dimension.constraint(lessThanOrEqualTo: otherDimension)
  }

  /// `anchor == otherAnchor * multiplier`
  /// - returns: `anchor.constraint(equalTo: otherAnchor, multiplier: multiplier)`
  @inlinable
  public static func == (dimension: NSLayoutDimension, attributes: _DimensionAttributes) -> NSLayoutConstraint {
    return dimension.constraint(equalTo: attributes.otherDimension, multiplier: attributes.multiplier)
  }

  /// `anchor >= otherAnchor * multiplier`
  /// - returns: `anchor.constraint(greaterThanOrEqualTo: otherAnchor, multiplier: multiplier)`
  @inlinable
  public static func >= (dimension: NSLayoutDimension, attributes: _DimensionAttributes) -> NSLayoutConstraint {
    return dimension.constraint(greaterThanOrEqualTo: attributes.otherDimension, multiplier: attributes.multiplier)
  }

  /// `anchor <= otherAnchor * multiplier`
  /// - returns: `anchor.constraint(lessThanOrEqualTo: otherAnchor, multiplier: multiplier)`
  @inlinable
  public static func <= (dimension: NSLayoutDimension, attributes: _DimensionAttributes) -> NSLayoutConstraint {
    return dimension.constraint(lessThanOrEqualTo: attributes.otherDimension, multiplier: attributes.multiplier)
  }

  // MARK: Operator provider using constant

  /// `anchor == constant`
  /// - returns: `anchor.constraint(equalToConstant: constant)`
  @inlinable
  public static func == (dimension: NSLayoutDimension, constant: CGFloat) -> NSLayoutConstraint {
    return dimension.constraint(equalToConstant: constant)
  }

  /// `anchor >= constant`
  /// - returns: `anchor.constraint(greaterThanOrEqualToConstant: constant)`
  @inlinable
  public static func >= (dimension: NSLayoutDimension, constant: CGFloat) -> NSLayoutConstraint {
    return dimension.constraint(greaterThanOrEqualToConstant: constant)
  }

  /// `anchor <= constant`
  /// - returns: `anchor.constraint(lessThanOrEqualToConstant: constant)`
  @inlinable
  public static func <= (dimension: NSLayoutDimension, constant: CGFloat) -> NSLayoutConstraint {
    return dimension.constraint(lessThanOrEqualToConstant: constant)
  }

  @inlinable
  public static func * (otherDimension: NSLayoutDimension, multiplier: CGFloat) -> _DimensionAttributes {
    return _DimensionAttributes(otherDimension: otherDimension, multiplier: multiplier)
  }
}
