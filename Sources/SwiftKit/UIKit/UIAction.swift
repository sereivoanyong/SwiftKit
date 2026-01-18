//
//  UIAction.swift
//
//  Created by Sereivoan Yong on 2/19/22.
//

import UIKit

@available(iOS 13.0, *)
extension UIAction: @retroactive Identifiable {

  @inlinable
  public var id: Identifier {
    return identifier
  }
}

@available(iOS 13.0, *)
extension UIAction {

  public var handler: UIActionHandler {
    typealias Block = @convention(block) (UIAction) -> Void
    let handler = value(forKey: "handler") as AnyObject
    return unsafeBitCast(handler, to: Block.self)
  }

  public struct Configuration: Hashable, Sendable {

    public var title: String
    public var subtitle: String?
    public var image: UIImage?

    public init(title: String, subtitle: String? = nil, image: UIImage? = nil) {
      self.title = title
      self.subtitle = subtitle
      self.image = image
    }
  }

  @available(iOS 15.0, *)
  public convenience init(configuration: Configuration, identifier: UIAction.Identifier? = nil, discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off, handler: @escaping UIActionHandler) {
    self.init(title: configuration.title, subtitle: configuration.subtitle, image: configuration.image, identifier: identifier, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state, handler: handler)
  }
}
