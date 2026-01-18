//
//  NSCollectionLayoutDimension.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/19/26.
//

import UIKit

@available(iOS 13.0, *)
extension NSCollectionLayoutDimension {

  @inlinable
  public static func + (lhs: NSCollectionLayoutDimension, rhs: CGFloat) -> NSCollectionLayoutDimension {
    if lhs.isFractionalWidth {
      return fractionalWidth(lhs.dimension + rhs)
    }
    if lhs.isFractionalHeight {
      return fractionalHeight(lhs.dimension + rhs)
    }
    if lhs.isEstimated {
      return estimated(lhs.dimension + rhs)
    }
    if lhs.isAbsolute {
      return absolute(lhs.dimension + rhs)
    }
    if #available(iOS 17.0, *), lhs.isUniformAcrossSiblings {
      return uniformAcrossSiblings(estimate: lhs.dimension + rhs)
    }
    assertionFailure()
    return lhs
  }
}
