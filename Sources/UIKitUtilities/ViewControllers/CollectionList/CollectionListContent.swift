//
//  CollectionListContent.swift
//
//  Created by Sereivoan Yong on 11/21/23.
//

import Foundation

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

  public func apply(to configuration: inout UIListContentConfiguration) {
    configuration.image = image
    configuration.text = text
    configuration.secondaryText = secondaryText
  }
}
