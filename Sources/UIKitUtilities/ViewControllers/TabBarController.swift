//
//  TabBarController.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/13/25.
//

import UIKit

open class TabBarController: UITabBarController {

  open override var selectedIndex: Int {
    didSet {
#if targetEnvironment(macCatalyst)
      if presentingViewController == nil {
        scene?.item = (topViewControllerForScene ?? self).sceneItem
      }
#endif
    }
  }
}
