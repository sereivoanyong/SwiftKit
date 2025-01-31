//
//  CollectionSection.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/21/23.
//

import UIKit

@available(iOS 14.0, *)
extension CollectionSection {

  public enum ListHeader: Hashable {

    case none
    case supplementary(CollectionContent)
    case firstItemInSection

    public static func supplementary(image: UIImage? = nil, text: String? = nil, secondaryText: String? = nil) -> Self {
      return supplementary(.list(image: image, text: text, secondaryText: secondaryText))
    }

    public var content: CollectionContent? {
      switch self {
      case .none:
        return nil
      case .supplementary(let content):
        return content
      case .firstItemInSection:
        return nil
      }
    }

    public var mode: UICollectionLayoutListConfiguration.HeaderMode {
      switch self {
      case .none:
        return .none
      case .supplementary:
        return .supplementary
      case .firstItemInSection:
        return .firstItemInSection
      }
    }
  }

  public enum ListFooter: Hashable {

    case none
    case supplementary(CollectionContent)

    public static func supplementary(image: UIImage? = nil, text: String? = nil, secondaryText: String? = nil) -> Self {
      return supplementary(.list(image: image, text: text, secondaryText: secondaryText))
    }

    public var content: CollectionContent? {
      switch self {
      case .none:
        return nil
      case .supplementary(let content):
        return content
      }
    }

    public var mode: UICollectionLayoutListConfiguration.FooterMode {
      switch self {
      case .none:
        return .none
      case .supplementary:
        return .supplementary
      }
    }
  }
}

@available(iOS 14.0, *)
extension CollectionSection {

  public enum Content: Hashable {

    case list(ListHeader, ListFooter)

    case custom(NSCollectionLayoutSection)
  }
}

@available(iOS 14.0, *)
public struct CollectionSection: Hashable, Identifiable {

  public let id: UUID
  public let content: Content

  public static func list(id: UUID = UUID(), header: ListHeader = .none, footer: ListFooter = .none) -> CollectionSection {
    return .init(id: id, content: .list(header, footer))
  }
}
