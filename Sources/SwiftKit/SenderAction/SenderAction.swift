//
//  SenderAction.swift
//
//  Created by Sereivoan Yong on 6/19/21.
//

import UIKit

final public class SenderAction<Sender: NSObjectProtocol> {

  public typealias Identifier = UUID

  public typealias Handler = (Sender) -> Void

  public let identifier: Identifier
  public var handler: Handler

  public init(identifier: Identifier? = nil, handler: @escaping (Sender) -> Void) {
    self.identifier = identifier ?? UUID()
    self.handler = handler
  }

  @objc public func invoke(_ sender: NSObjectProtocol) {
    assert(type(of: sender) == Sender.self)
    handler(sender as! Sender)
  }
}
