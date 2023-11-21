//
//  CollectionListItem.swift
//
//  Created by Sereivoan Yong on 11/2/23.
//

import UIKit

@available(iOS 14.0, *)
public struct CollectionListItem: Hashable, Identifiable {

  public let id: UUID
  public let content: CollectionListContent

  public init(id: UUID = UUID(), content: CollectionListContent) {
    self.id = id
    self.content = content
  }

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
