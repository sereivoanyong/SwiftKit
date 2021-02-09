//
//  Action.swift
//
//  Created by Sereivoan Yong on 12/1/20.
//

import UIKit

@objc open class Action: NSObject {

  /// A type that represents an action identifier.
  public struct Identifier: Hashable, RawRepresentable {

    public let rawValue: String

    public init(_ rawValue: String) {
      self.rawValue = rawValue
    }

    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }

  /// The action's title.
  public let title: String?

  /// The action's image.
  public let image: UIImage?

  /// The unique identifier for the action.
  public let identifier: Identifier

  /// The object responsible for the action handler.
  public private(set) var sender: Any?

  let handler: (Action) -> Void

  public init(title: String? = nil, image: UIImage? = nil, identifier: Identifier? = nil, handler: @escaping (Action) -> Void) {
    self.title = title
    self.image = image
    self.identifier = identifier ?? Identifier(UUID().uuidString)
    self.handler = handler
  }

  @objc func invoke(_ sender: Any) {
    self.sender = sender
    handler(self)
    self.sender = nil
  }
}

final class GenericAction<Sender>: Action {

  let genericHandler: (Sender) -> Void

  init(title: String? = nil, image: UIImage? = nil, identifier: Identifier? = nil, genericHandler: @escaping (Sender) -> Void) {
    self.genericHandler = genericHandler
    super.init(title: title, image: image, identifier: identifier, handler: { action in genericHandler(action.sender as! Sender) })
  }
}
