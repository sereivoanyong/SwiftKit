//
//  CALayer.swift
//
//  Created by Sereivoan Yong on 3/25/16.
//

import QuartzCore

extension CALayer {

  public static func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    actionsWithoutAnimation()
    CATransaction.commit()
  }

  // MARK: Corner

  public var continuousCorners: Bool {
    get { return valueIfResponds(forKey: "continuousCorners") as? Bool ?? false }
    set { setValueIfResponds(newValue, forKey: "continuousCorners") }
  }

  public func setCorner(radius: CGFloat = 0, masks: CACornerMask = .all, continuous: Bool = false) {
    cornerRadius = radius
    maskedCorners = masks
    continuousCorners = continuous
  }

  @available(iOS 13.0, macCatalyst 13.1, *)
  public func setCorner(radius: CGFloat = 0, masks: CACornerMask = .all, curve: CALayerCornerCurve = .circular) {
    cornerRadius = radius
    maskedCorners = masks
    cornerCurve = curve
  }

  // MARK: Border

  public struct Border: Equatable {

    public var width: CGFloat
    public var color: CGColor?

    public init(width: CGFloat = 0, color: CGColor? = nil) {
      self.width = width
      self.color = color
    }
  }

  public var border: Border {
    get { return Border(width: borderWidth, color: borderColor) }
    set { setBorder(width: newValue.width, color: newValue.color) }
  }

  public func setBorder(width: CGFloat = 0, color: CGColor? = nil) {
    borderWidth = width
    borderColor = color
  }

  // MARK: Shadow

  public struct Shadow: Equatable {

    public var color: CGColor?
    public var opacity: Float
    public var offset: CGSize
    public var radius: CGFloat
    public var path: CGPath?

    public init(color: CGColor? = nil, opacity: Float = 0, offset: CGSize = CGSize(width: 0, height: -3), radius: CGFloat = 3, path: CGPath? = nil) {
      self.color = color
      self.opacity = opacity
      self.offset = offset
      self.radius = radius
      self.path = path
    }
  }

  public var shadow: Shadow {
    get { return Shadow(color: shadowColor, opacity: shadowOpacity, offset: shadowOffset, radius: shadowRadius, path: shadowPath) }
    set { setShadow(color: newValue.color, opacity: newValue.opacity, offset: newValue.offset, radius: newValue.radius, path: newValue.path) }
  }

  public func setShadow(color: CGColor? = nil, opacity: Float = 0, offset: CGSize = CGSize(width: 0, height: -3), radius: CGFloat = 3, path: CGPath? = nil) {
    shadowColor = color
    shadowOpacity = opacity
    shadowOffset = offset
    shadowRadius = radius
    shadowPath = path
  }
}

extension CACornerMask {

  public static var all: CACornerMask {
    return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
}
