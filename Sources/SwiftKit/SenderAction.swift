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

  // For gesture recognizers only
  init(identifier: Identifier? = nil, handler: @escaping (Sender) -> Void) {
    self.identifier = identifier ?? UUID()
    self.handler = handler
  }

  @objc func invoke(_ sender: NSObjectProtocol) {
    assert(type(of: sender) == Sender.self)
    handler(sender as! Sender)
  }
}
