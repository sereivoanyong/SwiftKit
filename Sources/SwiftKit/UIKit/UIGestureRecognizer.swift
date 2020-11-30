//
//  UIGestureRecognizer.swift
//
//  Created by Sereivoan Yong on 2/4/20.
//

#if canImport(UIKit)
import UIKit

final private class Target<T> {
  
  let handler: (T) -> Void
  
  init(handler: @escaping (T) -> Void) {
    self.handler = handler
  }
  
  @objc func handle(_ object: NSObject) {
    handler(object as! T)
  }
}

public protocol UIGestureRecognizerProtocol: NSObjectProtocol {
  
  init(target: Any?, action: Selector?)
}

private var kTargetsKey: Void?
extension UIGestureRecognizerProtocol {
  
  fileprivate var targets: [Target<Self>] {
    get { return associatedValue(forKey: &kTargetsKey, default: []) }
    set { setAssociatedValue(newValue, forKey: &kTargetsKey) }
  }
}

extension UIGestureRecognizerProtocol where Self: UIGestureRecognizer {
  
  public init(handler: @escaping (Self) -> Void) {
    let target = Target<Self>(handler: handler)
    self.init(target: target, action: #selector(Target<Self>.handle(_:)))
    targets.append(target)
  }
  
  /// Adds action handler to a gesture-recognizer object.
  /// - Parameter handler: The handler to be called by the action message.
  /// - Returns: The token used to remove handler
  @discardableResult public func addHandler(_ handler: @escaping (Self) -> Void) -> AnyObject {
    let actionedTarget = Target<Self>(handler: handler)
    targets.append(actionedTarget)
    addTarget(actionedTarget, action: #selector(Target<Self>.handle(_:)))
    return actionedTarget
  }
  
  /// Removes action handler using specified token.
  /// - Parameter token: The token that is returned by calling `addHandler(_:)`
  /// - Returns: A boolean value indicating whether the handler is found and removed using specified `token`.
  @discardableResult
  public func removeHandler(_ token: AnyObject) -> Bool {
    for actionedTarget in targets where actionedTarget === token {
      removeTarget(actionedTarget, action: #selector(Target<Self>.handle(_:)))
      return true
    }
    return false
  }
}

extension UIGestureRecognizer: UIGestureRecognizerProtocol { }
#endif
