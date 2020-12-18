//
//  Action.swift
//
//  Created by Sereivoan Yong on 12/1/20.
//

import Foundation

final public class Action<Sender: NSObjectProtocol> {
  
  public typealias Identifier = UUID
  
  enum Handler {
    
    case action((Action<Sender>) -> Void)
    case sender((Sender) -> Void)
  }
  
  public let identifier: Identifier
  var handler: Handler
  
  /// Available only after `handler` is called.
  public private(set) var sender: Sender?
  
  public init(identifier: Identifier = UUID(), handler: @escaping (Action<Sender>) -> Void) {
    self.identifier = identifier
    self.handler = .action(handler)
  }
  
  // For gesture recognizers only
  init(identifier: Identifier = UUID(), handler: @escaping (Sender) -> Void) {
    self.identifier = identifier
    self.handler = .sender(handler)
  }
  
  @objc func invoke(_ sender: NSObjectProtocol) {
    assert(type(of: sender) == Sender.self)
    let sender = sender as! Sender
    self.sender = sender
    switch handler {
    case .action(let handler):
      handler(self)
    case .sender(let handler):
      handler(sender)
    }
  }
}
