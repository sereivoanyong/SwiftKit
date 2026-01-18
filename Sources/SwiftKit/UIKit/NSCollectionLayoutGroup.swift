//
//  NSCollectionLayoutGroup.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/18/26.
//

import UIKit

@available(iOS 13.0, *)
@_marker public protocol __NSCollectionLayoutGroupProtocol {
}

@available(iOS 13.0, *)
extension NSCollectionLayoutGroup: __NSCollectionLayoutGroupProtocol {
}

@available(iOS 13.0, *)
@frozen public enum CollectionLayoutDirection: String {

  case horizontal = "h"
  case vertical = "v"
}

@available(iOS 13.0, *)
extension __NSCollectionLayoutGroupProtocol where Self: NSCollectionLayoutGroup {

  /// if `layoutSize` is nil, width and height dimensions of  any`subitems` must not be fractional.
  public init(_ layoutDirection: CollectionLayoutDirection, layoutSize: NSCollectionLayoutSize? = nil, subitems: [NSCollectionLayoutItem], interItemSpacing: CGFloat = 0) {
    switch layoutDirection {
    case .horizontal:
      let layoutSize = layoutSize ?? {
        var totalWidth: CGFloat = interItemSpacing * CGFloat(subitems.count - 1)
        var hasEstimatedWidthDimension: Bool = false
        var layoutHeight: NSCollectionLayoutDimension!
        for subitem in subitems {
          let subitemLayoutSize = subitem.layoutSize
          assert(subitemLayoutSize.widthDimension.isEstimated || subitemLayoutSize.widthDimension.isAbsolute, "Only estimated and absolute dimensions are currently supported")
          totalWidth += subitemLayoutSize.widthDimension.dimension
          if subitemLayoutSize.widthDimension.isEstimated {
            hasEstimatedWidthDimension = true
          }
          if layoutHeight == nil {
            layoutHeight = subitemLayoutSize.heightDimension
          } else {
            // Fractional height is top priority
            if subitemLayoutSize.heightDimension.isFractionalHeight {
              if !layoutHeight.isFractionalHeight || subitemLayoutSize.heightDimension.dimension > layoutHeight.dimension {
                layoutHeight = subitemLayoutSize.heightDimension
              }
            } else if subitemLayoutSize.heightDimension.dimension > layoutHeight.dimension {
              layoutHeight = subitemLayoutSize.heightDimension
            }
          }
        }
        let layoutWidth: NSCollectionLayoutDimension = hasEstimatedWidthDimension ? .estimated(totalWidth) : .absolute(totalWidth)
        return NSCollectionLayoutSize(widthDimension: layoutWidth, heightDimension: layoutHeight)
      }()
      self = Self.horizontal(layoutSize: layoutSize, subitems: subitems)

    case .vertical:
      let layoutSize = layoutSize ?? {
        var layoutWidth: NSCollectionLayoutDimension!
        var totalHeight: CGFloat = interItemSpacing * CGFloat(subitems.count - 1)
        var hasEstimatedHeightDimension: Bool = false
        for subitem in subitems {
          let subitemLayoutSize = subitem.layoutSize
          assert(subitemLayoutSize.heightDimension.isEstimated || subitemLayoutSize.heightDimension.isAbsolute, "Only estimated and absolute dimensions are currently supported")
          totalHeight += subitemLayoutSize.heightDimension.dimension
          if subitemLayoutSize.heightDimension.isEstimated {
            hasEstimatedHeightDimension = true
          }
          if layoutWidth == nil {
            layoutWidth = subitemLayoutSize.widthDimension
          } else {
            // Fractional width is top priority
            if subitemLayoutSize.widthDimension.isFractionalWidth {
              if !layoutWidth.isFractionalWidth || subitemLayoutSize.widthDimension.dimension > layoutWidth.dimension {
                layoutWidth = subitemLayoutSize.widthDimension
              }
            } else if subitemLayoutSize.widthDimension.dimension > layoutWidth.dimension {
              layoutWidth = subitemLayoutSize.widthDimension
            }
          }
        }
        let layoutHeight: NSCollectionLayoutDimension = hasEstimatedHeightDimension ? .estimated(totalHeight) : .absolute(totalHeight)
        return NSCollectionLayoutSize(widthDimension: layoutWidth, heightDimension: layoutHeight)
      }()
      self = Self.vertical(layoutSize: layoutSize, subitems: subitems)
    }
    self.interItemSpacing = .fixed(interItemSpacing)
  }

  /// if `layoutSize` is nil, width and height dimensions of `repeatedSubitem` must not be fractional.
  public init(_ layoutDirection: CollectionLayoutDirection, layoutSize: NSCollectionLayoutSize? = nil, repeating repeatedSubitem: NSCollectionLayoutItem, count: Int, interItemSpacing: CGFloat = 0) {
    switch layoutDirection {
    case .horizontal:
      let layoutSize = layoutSize ?? {
        let layoutWidth: NSCollectionLayoutDimension
        let layoutItemWidth = repeatedSubitem.layoutSize.widthDimension
        if layoutItemWidth.isFractionalWidth {
          layoutWidth = .fractionalWidth(layoutItemWidth.dimension * CGFloat(count))
        } else if layoutItemWidth.isAbsolute {
          layoutWidth = .absolute(layoutItemWidth.dimension * CGFloat(count) + interItemSpacing * CGFloat(count - 1))
        } else if layoutItemWidth.isEstimated {
          layoutWidth = .estimated(layoutItemWidth.dimension * CGFloat(count) + interItemSpacing * CGFloat(count - 1))
        } else if #available(iOS 17.0, *), layoutItemWidth.isUniformAcrossSiblings {
          layoutWidth = .uniformAcrossSiblings(estimate: layoutItemWidth.dimension * CGFloat(count) + interItemSpacing * CGFloat(count - 1))
        } else {
          assertionFailure()
          layoutWidth = layoutItemWidth
        }
        return NSCollectionLayoutSize(widthDimension: layoutWidth, heightDimension: repeatedSubitem.layoutSize.heightDimension)
      }()
      if #available(iOS 16.0, *) {
        self = Self.horizontal(layoutSize: layoutSize, repeatingSubitem: repeatedSubitem, count: count)
      } else {
        self = Self.horizontal(layoutSize: layoutSize, subitem: repeatedSubitem, count: count)
      }

    case .vertical:
      let layoutSize = layoutSize ?? {
        let layoutHeight: NSCollectionLayoutDimension
        let layoutItemHeight = repeatedSubitem.layoutSize.heightDimension
        if layoutItemHeight.isFractionalHeight {
          layoutHeight = .fractionalHeight(layoutItemHeight.dimension * CGFloat(count))
        } else if layoutItemHeight.isAbsolute {
          layoutHeight = .absolute(layoutItemHeight.dimension * CGFloat(count) + interItemSpacing * CGFloat(count - 1))
        } else if layoutItemHeight.isEstimated {
          layoutHeight = .estimated(layoutItemHeight.dimension * CGFloat(count) + interItemSpacing * CGFloat(count - 1))
        } else if #available(iOS 17.0, *), layoutItemHeight.isUniformAcrossSiblings {
          layoutHeight = .uniformAcrossSiblings(estimate: layoutItemHeight.dimension * CGFloat(count) + interItemSpacing * CGFloat(count - 1))
        } else {
          assertionFailure()
          layoutHeight = layoutItemHeight
        }
        return NSCollectionLayoutSize(widthDimension: repeatedSubitem.layoutSize.widthDimension, heightDimension: layoutHeight)
      }()
      if #available(iOS 16.0, *) {
        self = Self.vertical(layoutSize: layoutSize, repeatingSubitem: repeatedSubitem, count: count)
      } else {
        self = Self.vertical(layoutSize: layoutSize, subitem: repeatedSubitem, count: count)
      }
    }
    self.interItemSpacing = .fixed(interItemSpacing)
  }
}
