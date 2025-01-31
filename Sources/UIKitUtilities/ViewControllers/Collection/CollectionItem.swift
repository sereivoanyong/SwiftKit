//
//  CollectionItem.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/2/23.
//

import UIKit

@available(iOS 14.0, *)
public struct CollectionItem: Hashable, Identifiable {

  public let id: UUID
  public let content: CollectionContent

  public static func list(
    id: UUID = UUID(),
    image: UIImage? = nil,
    text: String? = nil,
    secondaryText: String? = nil
  ) -> CollectionItem {
    return .init(id: id, content: .list(image: image, text: text, secondaryText: secondaryText))
  }
}
