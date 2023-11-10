//
//  BCConfigurationColorTransformer.swift
//
//  Created by Sereivoan Yong on 10/4/23.
//

import UIKit

/// `UIConfigurationColorTransformer`
public struct BCConfigurationColorTransformer {

  public let transform: (UIColor) -> UIColor

  public init(_ transform: @escaping (UIColor) -> UIColor) {
    self.transform = transform
  }

  public func callAsFunction(_ input: UIColor) -> UIColor {
    return transform(input)
  }
}
