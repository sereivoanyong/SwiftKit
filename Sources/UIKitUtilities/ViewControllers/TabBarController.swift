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
      scene?.item = viewControllers?[selectedIndex].topViewControllerForScene.sceneItem
#endif
    }
  }
}
