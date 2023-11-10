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

public typealias ActionHandler = (Action) -> Void

/// A menu element that performs its action in a closure.
///
/// Create an `Action` object when you want a menu element that performs its action in a closure.
open class Action: MenuElement {

  /// The unique identifier for the action.
  public let identifier: Identifier

  open var attributedTitle: NSAttributedString?

  /// The attributes indicating the style of the action.
  open var attributes: Attributes

  open var state: State

  open var handler: ActionHandler

  /// The object responsible for the action handler.
  public private(set) var sender: Any?

  public init(
    title: String? = nil,
    subtitle: String? = nil,
    image: UIImage? = nil,
    identifier: Identifier? = nil,
    attributes: Attributes = [],
    state: State = .off,
    handler: @escaping ActionHandler
  ) {
    self.identifier = identifier ?? Identifier(UUID().uuidString)
    self.attributes = attributes
    self.state = state
    self.handler = handler
    super.init(title: title, subtitle: subtitle, image: image)
//    UIAction
  }

  @objc open func performAction(_ sender: Any) {
    self.sender = sender
    handler(self)
    self.sender = nil
  }
}
