//
//  KeyboardNotification.swift
//
//  Created by Sereivoan Yong on 1/5/24.
//

import UIKit

public struct KeyboardNotification {

  public weak var screen: UIScreen?
  public let frameBegin: CGRect
  public let frameEnd: CGRect
  public let animationDuration: TimeInterval
  public let animationOptions: UIView.AnimationOptions
  public let isLocal: Bool

  public init?(_ notification: Notification) {
    guard let userInfo = notification.userInfo else { return nil }
    // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
    screen = notification.object as? UIScreen
    frameBegin = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
    frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
    animationOptions = UIView.AnimationOptions(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt) << 16)
    isLocal = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
  }

  public func convertedKeyboardFrameEnd(_ view: UIView) -> CGRect {
    if let screen {
      return screen.coordinateSpace.convert(frameEnd, to: view)
    } else {
      return view.convert(frameEnd, from: view.window)
    }
  }

  public func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: animations, completion: completion)
  }
}
