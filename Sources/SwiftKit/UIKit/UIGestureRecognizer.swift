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
  
  private var actions: [SenderAction<Self>.Identifier: SenderAction<Self>] {
    get { associatedValue(forKey: &kActionsKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &kActionsKey) }
  }
  
  public init(identifier: SenderAction<Self>.Identifier? = nil, handler: @escaping (Self) -> Void) {
    let action = SenderAction<Self>(identifier: identifier, handler: handler)
    self.init(target: action, action: #selector(SenderAction<Self>.invoke(_:)))
    actions[action.identifier] = action
  }
  
  /// Adds action handler to a gesture-recognizer object. If the same identifier is found, the handler will replaced instead of being added.
  /// - Parameter handler: The handler to be called by the action message.
  /// - Returns: The token used to remove handler
  public func addAction(identifier: SenderAction<Self>.Identifier? = nil, handler: @escaping (Self) -> Void) {
    if let identifier, let action = actions[identifier] {
      removeTarget(action, action: #selector(SenderAction<Self>.invoke(_:)))
    }
    let action = SenderAction<Self>(identifier: identifier, handler: handler)
    addTarget(action, action: #selector(SenderAction<Self>.invoke(_:)))
    actions[action.identifier] = action
  }
  
  /// Removes action handler using specified token.
  /// - Parameter token: The token that is returned by calling `addHandler(_:)`
  /// - Returns: A boolean value indicating whether the handler is found and removed using specified `token`.
  @discardableResult
  public func removeAction(identifier: SenderAction<Self>.Identifier) -> Bool {
    if let action = actions.removeValue(forKey: identifier) {
      removeTarget(action, action: #selector(SenderAction<Self>.invoke(_:)))
      return true
    }
    return false
  }
}

extension UIGestureRecognizer: UIGestureRecognizerProtocol { }
#endif
