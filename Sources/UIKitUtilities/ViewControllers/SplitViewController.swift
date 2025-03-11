//
//  SplitViewController.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/11/25.
//

import UIKit

open class SplitViewController: UISplitViewController {

  @available(iOS 14.0, *)
  open override func setViewController(_ viewController: UIViewController?, for column: Column) {
    super.setViewController(viewController, for: column)
#if targetEnvironment(macCatalyst)
    if column == .secondary {
      scene?.item = viewController?.topViewControllerForScene.sceneItem
    }
#endif
  }
}
