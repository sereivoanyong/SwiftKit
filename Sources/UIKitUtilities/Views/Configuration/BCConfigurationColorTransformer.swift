//
//  BCConfigurationColorTransformer.swift
//
//  Created by Sereivoan Yong on 10/4/23.
//

import UIKit

/// `UIConfigurationColorTransformer`
public struct BCConfigurationColorTransformer: Hashable {

  private let id: UUID = UUID()

  public let transform: (UIColor) -> UIColor

  public init(_ transform: @escaping (UIColor) -> UIColor) {
    self.transform = transform
  }

  public func callAsFunction(_ input: UIColor) -> UIColor {
    return transform(input)
  }

  public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
    return lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
