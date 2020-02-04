//
//  UIGestureRecognizer+ActionHandler.swift
//
//  Created by Sereivoan Yong on 2/4/20.
//

#if canImport(UIKit)
import UIKit

public protocol UIGestureRecognizerProtocol: NSObjectProtocol {
  
  init(target: Any?, action: Selector?)
}

private var kActionedTargetsKey: Void?
extension UIGestureRecognizerProtocol {
  
  fileprivate var actionedTargets: [ActionedTarget<Self>] {
    get { return associatedValue(forKey: &kActionedTargetsKey, default: []) }
    set { setAssociatedValue(newValue, forKey: &kActionedTargetsKey) }
  }
}

extension UIGestureRecognizer: UIGestureRecognizerProtocol { }

final private class ActionedTarget<T> {
  
  let handler: (T) -> Void
  
  init(handler: @escaping (T) -> Void) {
    self.handler = handler
  }
  
  @objc func handle(_ object: NSObject) {
    handler(object as! T)
  }
}

extension UIGestureRecognizerProtocol where Self: UIGestureRecognizer {
  
  public init(handler: @escaping (Self) -> Void) {
    let actionedTarget = ActionedTarget<Self>(handler: handler)
    self.init(target: actionedTarget, action: #selector(ActionedTarget<Self>.handle(_:)))
    actionedTargets.append(actionedTarget)
  }
  
  /// Adds action handler to a gesture-recognizer object.
  /// - Parameter handler: The handler to be called by the action message.
  /// - Returns: The token used to remove handler
  @discardableResult public func addHandler(_ handler: @escaping (_ gestureRecognizer: Self) -> Void) -> AnyObject {
    let actionedTarget = ActionedTarget<Self>(handler: handler)
    actionedTargets.append(actionedTarget)
    addTarget(actionedTarget, action: #selector(ActionedTarget<Self>.handle(_:)))
    return actionedTarget
  }
  
  /// Removes action handler using specified token.
  /// - Parameter token: The token that is returned by calling `addHandler(_:)`
  /// - Returns: A boolean value indicating whether the handler is found and removed using specified `token`.
  @discardableResult
  public func removeHandler(_ token: AnyObject) -> Bool {
    for actionedTarget in actionedTargets where actionedTarget === token {
      removeTarget(actionedTarget, action: #selector(ActionedTarget<Self>.handle(_:)))
      return true
    }
    return false
  }
}
#endif
