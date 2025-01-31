//
//  CollectionContent.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/21/23.
//

@available(iOS 14.0, *)
public enum CollectionContent: Hashable {

  case list(image: UIImage?, text: String?, secondaryText: String?)
}

@available(iOS 14.0, *)
extension UIListContentConfiguration {

  public mutating func apply(_ content: CollectionContent) {
    switch content {
    case .list(let image, let text, let secondaryText):
      self.image = image
      self.text = text
      self.secondaryText = secondaryText
    }
  }
}
