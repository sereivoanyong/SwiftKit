//
//  UIWindow.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

import UIKit

extension UIWindow {

  public func setRootViewController(_ viewController: UIViewController, animated: Bool, duration: TimeInterval, options: AnimationOptions, completion: ((Bool) -> Void)? = nil) {
    guard animated else {
      rootViewController = viewController
      completion?(true)
      return
    }

    UIView.transition(with: self, duration: duration, options: options, animations: {
      let oldState = UIView.areAnimationsEnabled
      UIView.setAnimationsEnabled(false)
      self.rootViewController = viewController
      UIView.setAnimationsEnabled(oldState)
    }, completion: completion)
  }

  /*
  public func setRootViewController(_ rootViewController: UIViewController?, animated: Bool) {
    guard animated, let newRootViewController = rootViewController, let oldRootViewController = self.rootViewController else {
      self.rootViewController = rootViewController
      return
    }
    let targetView = newRootViewController.view!
    let imageView = UIImageView(frame: targetView.bounds)
    imageView.autoresizingMask = .flexibleSize
    imageView.image = (oldRootViewController.topPresentedViewController ?? oldRootViewController).capturedScreenshot()
    targetView.addSubview(imageView)
    
    self.rootViewController = rootViewController
    
    UIView.animate(withDuration: 0.6, animations: {
      imageView.alpha = 0
    }, completion: { _ in
      imageView.removeFromSuperview()
    })
  }
  */

  public func dismiss() {
    isHidden = true
    if #available(iOS 13.0, *) {
      windowScene = nil
    }
  }
}
