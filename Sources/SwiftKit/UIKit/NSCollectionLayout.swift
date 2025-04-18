//
//  NSCollectionLayout.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/18/25.
//

import UIKit

@available(iOS 13.0, *)
extension NSCollectionLayoutBoundarySupplementaryItem {

  @inlinable
  public convenience init(layoutSize: NSCollectionLayoutSize, kind: UICollectionView.ElementKind, alignment: NSRectAlignment) {
    self.init(layoutSize: layoutSize, elementKind: kind.rawValue, alignment: alignment)
  }

  @inlinable
  public convenience init(layoutSize: NSCollectionLayoutSize, kind: UICollectionView.ElementKind, alignment: NSRectAlignment, absoluteOffset: CGPoint) {
    self.init(layoutSize: layoutSize, elementKind: kind.rawValue, alignment: alignment, absoluteOffset: absoluteOffset)
  }
}


@available(iOS 13.0, *)
extension NSCollectionLayoutDecorationItem {

  @inlinable
  public static func background(kind: UICollectionView.ElementKind) -> Self {
    return background(elementKind: kind.rawValue)
  }

  @inlinable
  public static func sectionBackground() -> Self {
    return background(kind: .sectionBackground)
  }
}
