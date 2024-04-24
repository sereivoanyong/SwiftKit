//
//  NavigationController.swift
//
//  Created by Sereivoan Yong on 11/1/23.
//

import UIKit
import SwiftKit

extension UINavigationItem {

  private static var usesCrossDissolveAnimatorWhenPushedAndPoppedKey: Void?
  public var usesCrossDissolveAnimatorWhenPushedAndPopped: Bool {
    get { return associatedValue(forKey: &Self.usesCrossDissolveAnimatorWhenPushedAndPoppedKey, with: self) ?? false }
    set { setAssociatedValue(newValue, forKey: &Self.usesCrossDissolveAnimatorWhenPushedAndPoppedKey, with: self) }
  }
}

open class NavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

  // MARK: View Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }

    // Fix swipe gesture stopped working when setting `leftBarButtonItem`
    interactivePopGestureRecognizer?.delegate = self
    delegate = self
  }

  open override var childForStatusBarStyle: UIViewController? {
    return topViewController
  }

  // MARK: UIGestureRecognizerDelegate

  open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer === interactivePopGestureRecognizer {
      return viewControllers.count > 1
    }
    return true
  }

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer === interactivePopGestureRecognizer {
      return true
    }
    return false
  }

  // MARK: UINavigationControllerDelegate

  open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

  }

  open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

  }

  open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }

  open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .none:
      break

    case .push:
      if toVC.navigationItem.usesCrossDissolveAnimatorWhenPushedAndPopped {
        return CrossDissolveAnimator(operation: operation)
      }

    case .pop:
      if fromVC.navigationItem.usesCrossDissolveAnimatorWhenPushedAndPopped {
        return CrossDissolveAnimator(operation: operation)
      }

    @unknown default:
      break
    }
    return nil
  }
}
