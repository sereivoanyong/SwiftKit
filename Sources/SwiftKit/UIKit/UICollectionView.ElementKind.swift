//
//  UICollectionView.ElementKind.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 12/9/24.
//

import UIKit

extension UICollectionView {

  public struct ElementKind: Hashable, RawRepresentable {

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

  public static let layoutHeader = Self("UICollectionElementKindLayoutHeader")

  public static let layoutFooter = Self("UICollectionElementKindLayoutFooter")

  public static let sectionHeader = Self(UICollectionView.elementKindSectionHeader)

  public static let sectionFooter = Self(UICollectionView.elementKindSectionFooter)

  public static let sectionBackground = Self(UICollectionView.elementKindSectionBackground)
}
