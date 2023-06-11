//
//  Action.swift
//
//  Created by Sereivoan Yong on 12/1/20.
//

import UIKit

extension Action {

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
}

// https://developer.limneos.net/index.php?ios=14.4&framework=UIKitCore.framework&header=UIAction.h
@objc open class Action: NSObject {

  open var handler: (Action) -> Void

  /// The action's title.
  open var title: String?

  /// The action's image.
  open var image: UIImage?

  /// The unique identifier for the action.
  open var identifier: Identifier

  /// The object responsible for the action handler.
  public private(set) var sender: Any?

  public init(title: String? = nil, image: UIImage? = nil, identifier: Identifier? = nil, handler: @escaping (Action) -> Void) {
    self.title = title
    self.image = image
    self.identifier = identifier ?? Identifier(UUID().uuidString)
    self.handler = handler
  }

  @objc open func performAction(_ sender: Any) {
    self.sender = sender
    handler(self)
    self.sender = nil
  }
}
