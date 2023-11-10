//
//  CollectionList.swift
//
//  Created by Sereivoan Yong on 11/2/23.
//

import UIKit

@available(iOS 14.0, *)
public struct CollectionListContent: Hashable {

  public let image: UIImage?
  public let text: String?
  public let secondaryText: String?

  public init(
    image: UIImage? = nil,
    text: String? = nil,
    secondaryText: String? = nil
  ) {
    self.image = image
    self.text = text
    self.secondaryText = secondaryText
  }

  public func apply(configuration: inout UIListContentConfiguration) {
    configuration.image = image
    configuration.text = text
    configuration.secondaryText = secondaryText
  }
}

@available(iOS 14.0, *)
public struct CollectionListSection: Hashable, Identifiable {

  public let id: UUID
  public let headerMode: UICollectionLayoutListConfiguration.HeaderMode
  public let footerMode: UICollectionLayoutListConfiguration.FooterMode
  public let content: CollectionListContent

  public init(
    id: UUID = UUID(),
    headerMode: UICollectionLayoutListConfiguration.HeaderMode = .none,
    footerMode: UICollectionLayoutListConfiguration.FooterMode = .none,
    image: UIImage? = nil,
    text: String? = nil,
    secondaryText: String? = nil
  ) {
    self.id = id
    self.headerMode = headerMode
    self.footerMode = footerMode
    self.content = .init(image: image, text: text, secondaryText: secondaryText)
  }
}

@available(iOS 14.0, *)
public struct CollectionListItem: Hashable, Identifiable {

  public let id: UUID
  public let content: CollectionListContent

  public init(
    id: UUID = UUID(),
    image: UIImage? = nil,
    text: String? = nil,
    secondaryText: String? = nil
  ) {
    self.id = id
    self.content = .init(image: image, text: text, secondaryText: secondaryText)
  }
}
