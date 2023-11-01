//
//  UIViewController.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UIViewController {

  @IBAction open func dismiss(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction open func endEditing(_ sender: Any) {
    if isViewLoaded {
      view.endEditing(true)
    }
  }

  /// Check if ViewController is onscreen and not hidden.
  public var isVisible: Bool {
    // @see: http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
    return isViewLoaded && view.window != nil
  }

  /// Adds the specified view controller including its view as a child of the current view controller
  public func addChildIncludingView(_ childViewController: UIViewController, addHandler: (_ view: UIView, _ childView: UIView) -> Void) {
    addChild(childViewController)
    addHandler(view, childViewController.view)
    childViewController.didMove(toParent: self)
  }

  /// Removes the view controller including its view from its parent
  public func removeFromParentIncludingView() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }

  @discardableResult
  public func enableEndEditingOnTap(on view: UIView? = nil) -> UITapGestureRecognizer {
    let view = view ?? self.view!
    view.isUserInteractionEnabled = true
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    tapGestureRecognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGestureRecognizer)
    return tapGestureRecognizer
  }

  @objc
  public var topMostViewController: UIViewController? {
    if let navigationController = self as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
      return visibleViewController.topMostViewController
    }
    if let tabBarController = self as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
      return selectedViewController.topMostViewController
    }
    if let presentedViewController {
      return presentedViewController.topMostViewController
    }
    return self
  }

  public func show(on viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
    viewController.present(self, animated: animated, completion: completion)
  }

  public func show(animated: Bool, completion: (() -> Void)?) {
    UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
  }

  @inlinable
  public func showDetail(_ detailViewController: UIViewController, sender: Any?) {
    showDetailViewController(detailViewController, sender: sender)
  }

  public static var embeddingNavigationControllerClass: UINavigationController.Type?

  public func embeddingInNavigationController(configurationHandler: ((UINavigationController) -> Void)? = nil) -> UINavigationController {
    let navigationControllerClass = Self.embeddingNavigationControllerClass ?? UINavigationController.self
    let navigationController = navigationControllerClass.init(rootViewController: self)
    configurationHandler?(navigationController)
    return navigationController
  }
}
