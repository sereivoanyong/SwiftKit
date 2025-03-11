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

  public static var navigationBarClass: UINavigationBar.Type?

  public static var toolbarClass: UIToolbar.Type?

  private var overrideUserInterfaceStyleObservation: NSKeyValueObservation?

  // MARK: Initializers

  public init(navigationBarClass: UINavigationBar.Type? = nil, toolbarClass: UIToolbar.Type? = nil, rootViewController: UIViewController) {
    super.init(navigationBarClass: navigationBarClass ?? Self.navigationBarClass, toolbarClass: toolbarClass ?? Self.toolbarClass)
    setViewControllers([rootViewController], animated: false)
  }

  private override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
    super.init(navigationBarClass: navigationBarClass ?? Self.navigationBarClass, toolbarClass: toolbarClass ?? Self.toolbarClass)
  }

  public override init(nibName: String?, bundle: Bundle?) {
    super.init(nibName: nibName, bundle: bundle)
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

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

  open func updateProperties(from topViewController: UIViewController) {
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyleObservation = topViewController.observe(\.overrideUserInterfaceStyle, options: [.initial, .new]) { [unowned self] topViewController, _ in
        overrideUserInterfaceStyle = topViewController.overrideUserInterfaceStyle
      }
    }
  }

  // MARK: UIGestureRecognizerDelegate

  open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer === interactivePopGestureRecognizer {
      return viewControllers.count > 1
    }
    return true
  }

  open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer === interactivePopGestureRecognizer {
      return true
    }
    return false
  }

  // MARK: UINavigationControllerDelegate

  open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
#if targetEnvironment(macCatalyst)
    if presentingViewController == nil {
      let topViewControllerForScene = viewController.topViewControllerForScene ?? viewController
      topViewControllerForScene.navigationItem.title = nil
      scene?.item = topViewControllerForScene.sceneItem
    }
#endif
    updateProperties(from: viewController)
  }

  open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
#if targetEnvironment(macCatalyst)
    if presentingViewController == nil {
      let topViewControllerForScene = viewController.topViewControllerForScene ?? viewController
      topViewControllerForScene.navigationItem.title = nil
      scene?.item = topViewControllerForScene.sceneItem
    }
#endif
    updateProperties(from: viewController)
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
