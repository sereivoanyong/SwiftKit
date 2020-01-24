//
//  KeyboardObserver.swift
//
//  Created by Sereivoan Yong on 1/17/18.
//

import UIKit

public struct KeyboardTransition {
  
  public enum State {
    
    case willShow, willHide
  }
  
  public let state: State
  public let animationDuration: TimeInterval
  public let animationOptions: UIView.AnimationOptions
  public let beginFrame, endFrame: CGRect
  
  fileprivate init(for state: State, from notification: Notification) {
    self.state = state
    let userInfo = notification.userInfo.unsafelyUnwrapped
    beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
    endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    if endFrame.y - beginFrame.y == beginFrame.height - endFrame.height {
      // No animations needed here
      animationDuration = 0
      animationOptions = []
    } else {
      animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
      animationOptions = UIView.AnimationOptions(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt) << 16)
    }
  }
  
  public func animate(delay: TimeInterval = 0, animation: @escaping () -> Void, completion: ((Bool) -> Void)?) {
    if animationDuration == 0 {
      animation()
      completion?(true)
      return
    }
    UIView.animate(withDuration: animationDuration, delay: delay, options: animationOptions, animations: animation, completion: completion)
  }
}

public protocol KeyboardObserver: AnyObject {
  
  func observeKeyboard()
  func unobserveKeyboard()
  
  func handleKeyboardTransition(_ transition: KeyboardTransition)
}

private var kKeyboardFrameKey: Void?

extension KeyboardObserver {
  
  public fileprivate(set) var keyboardFrame: CGRect {
    get { return objc_getAssociatedObject(self, &kKeyboardFrameKey) as? CGRect ?? .zero }
    set { objc_setAssociatedObject(self, &kKeyboardFrameKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
  }
}

extension KeyboardObserver where Self: UIViewController {
  
  public func observeKeyboard() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  public func unobserveKeyboard() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
}

private extension UIViewController {
  
  @objc func keyboardWillShow(_ notification: Notification) {
    let transition = KeyboardTransition(for: .willShow, from: notification)
    let observer = self as! KeyboardObserver
    observer.keyboardFrame = transition.endFrame
    observer.handleKeyboardTransition(transition)
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    let transition = KeyboardTransition(for: .willHide, from: notification)
    let observer = self as! KeyboardObserver
    observer.keyboardFrame = transition.endFrame
    observer.handleKeyboardTransition(transition)
  }
}
