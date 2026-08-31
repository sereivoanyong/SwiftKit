//
//  BCBackgroundConfiguration.swift
//
//  Created by Sereivoan Yong on 10/4/23.
//

import UIKit

/// `UIBackgroundConfiguration`
public struct BCBackgroundConfiguration: Hashable {

  public var maskedCorners: UIRectCorner

  public var cornerRadius: CGFloat

  public var backgroundInsets: NSDirectionalEdgeInsets

  public var backgroundColor: UIColor?

  public var backgroundColorTransformer: BCConfigurationColorTransformer?

  public init(
    maskedCorners: UIRectCorner = .allCorners,
    cornerRadius: CGFloat = 0,
    backgroundInsets: NSDirectionalEdgeInsets = .zero,
    backgroundColor: UIColor? = nil,
    backgroundColorTransformer: BCConfigurationColorTransformer? = nil
  ) {
    self.maskedCorners = maskedCorners
    self.cornerRadius = cornerRadius
    self.backgroundInsets = backgroundInsets
    self.backgroundColor = backgroundColor
    self.backgroundColorTransformer = backgroundColorTransformer
  }

  public func resolvedBackgroundColor(for tintColor: UIColor) -> UIColor {
    let backgroundColor = backgroundColor ?? tintColor
    if let backgroundColorTransformer {
      return backgroundColorTransformer(backgroundColor)
    }
    return backgroundColor
  }
}
