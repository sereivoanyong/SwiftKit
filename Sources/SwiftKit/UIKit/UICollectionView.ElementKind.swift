//
//  UICollectionView.ElementKind.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 12/9/24.
//

import UIKit

extension UICollectionView {

  public struct ElementKind: Hashable, RawRepresentable, @unchecked Sendable {

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

  @MainActor public static let layoutHeader: Self = Self("UICollectionElementKindLayoutHeader")

  @MainActor public static let layoutFooter: Self = Self("UICollectionElementKindLayoutFooter")

  @MainActor public static let sectionHeader: Self = Self(UICollectionView.elementKindSectionHeader)

  @MainActor public static let sectionFooter: Self = Self(UICollectionView.elementKindSectionFooter)

  @MainActor public static let sectionSeparator: Self = Self("UICollectionElementKindSectionSeparator")

  @MainActor public static let sectionBackground: Self = Self("UICollectionElementKindSectionBackground")
}
