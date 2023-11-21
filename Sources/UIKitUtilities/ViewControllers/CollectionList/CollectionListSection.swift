//
//  CollectionListSection.swift
//
//  Created by Sereivoan Yong on 11/21/23.
//

import Foundation

@available(iOS 14.0, *)
extension CollectionListSection {

  public enum Header: Hashable {

    case none
    case supplementary(CollectionListContent)
    case firstItemInSection

    public static func supplementary(image: UIImage? = nil, text: String? = nil, secondaryText: String? = nil) -> Self {
      return supplementary(.init(image: image, text: text, secondaryText: secondaryText))
    }

    public var content: CollectionListContent? {
      switch self {
      case .none:
        return nil
      case .supplementary(let content):
        return content
      case .firstItemInSection:
        return nil
      }
    }
  }

  public enum Footer: Hashable {

    case none
    case supplementary(CollectionListContent)

    public static func supplementary(image: UIImage? = nil, text: String? = nil, secondaryText: String? = nil) -> Self {
      return supplementary(.init(image: image, text: text, secondaryText: secondaryText))
    }

    public var content: CollectionListContent? {
      switch self {
      case .none:
        return nil
      case .supplementary(let content):
        return content
      }
    }
  }
}

@available(iOS 14.0, *)
public struct CollectionListSection: Hashable, Identifiable {

  public let id: UUID
  public let header: Header
  public let footer: Footer

  public init(id: UUID = UUID(), header: Header = .none, footer: Footer = .none) {
    self.id = id
    self.header = header
    self.footer = footer
  }
}
