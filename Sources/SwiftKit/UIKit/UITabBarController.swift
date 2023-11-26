//
//  UITabBarController.swift
//
//  Created by Sereivoan Yong on 11/26/23.
//

#if canImport(UIKit)

import UIKit

extension UITabBarController {

  public override var topMostViewController: UIViewController? {
    if let selectedViewController {
      return selectedViewController.topMostViewController
    }
    return super.topMostViewController
  }
}

#endif
