//
//  UICollectionView.ElementKind.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 12/9/24.
//

import UIKit

extension UICollectionView {

  public struct ElementKind: Hashable, RawRepresentable, Sendable {

    public let rawValue: String

    public init(_ rawValue: String) {
      self.rawValue = rawValue
    }

    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }
}

extension UICollectionView.ElementKind: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self.rawValue = value
  }
}

extension UICollectionView.ElementKind {

  public static let layoutHeader: Self = Self("UICollectionElementKindLayoutHeader")

  public static let layoutFooter: Self = Self("UICollectionElementKindLayoutFooter")

  public static let sectionHeader: Self = Self(UICollectionView.elementKindSectionHeader)

  public static let sectionFooter: Self = Self(UICollectionView.elementKindSectionFooter)

  public static let sectionSeparator: Self = Self("UICollectionElementKindSectionSeparator")

  public static let sectionBackground: Self = Self("UICollectionElementKindSectionBackground")
}
