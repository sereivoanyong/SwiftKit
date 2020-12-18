//
//  UIGestureRecognizer.swift
//
//  Created by Sereivoan Yong on 2/4/20.
//

#if canImport(UIKit)
import UIKit

public protocol UIGestureRecognizerProtocol: NSObjectProtocol {
  
  init(target: Any?, action: Selector?)
  func addTarget(_ target: Any, action: Selector)
  func removeTarget(_ target: Any?, action: Selector?)
}

private var kActionsKey: Void?
extension UIGestureRecognizerProtocol {
  
  private var actions: [Action<Self>.Identifier: Action<Self>] {
    get { return associatedValue(forKey: &kActionsKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &kActionsKey) }
  }
  
  public init(identifier: Action<Self>.Identifier = UUID(), handler: @escaping (Self) -> Void) {
    let target = Action<Self>(identifier: identifier, handler: handler)
    self.init(target: target, action: #selector(Action<Self>.invoke(_:)))
    actions[target.identifier] = target
  }
  
  /// Adds action handler to a gesture-recognizer object. If the same identifier is found, the handler will replaced instead of being added.
  /// - Parameter handler: The handler to be called by the action message.
  /// - Returns: The token used to remove handler
  public func addAction(identifier: Action<Self>.Identifier = UUID(), handler: @escaping (Self) -> Void) {
    if let action = actions[identifier] {
      action.handler = .sender(handler)
    } else {
      let action = Action<Self>(identifier: identifier, handler: handler)
      addTarget(action, action: #selector(Action<Self>.invoke(_:)))
      actions[action.identifier] = action
    }
  }
  
  /// Removes action handler using specified token.
  /// - Parameter token: The token that is returned by calling `addHandler(_:)`
  /// - Returns: A boolean value indicating whether the handler is found and removed using specified `token`.
  @discardableResult
  public func removeAction(identifier: Action<Self>.Identifier) -> Bool {
    if let action = actions.removeValue(forKey: identifier) {
      removeTarget(action, action: #selector(Action<Self>.invoke(_:)))
      return true
    }
    return false
  }
}

extension UIGestureRecognizer: UIGestureRecognizerProtocol { }
#endif
