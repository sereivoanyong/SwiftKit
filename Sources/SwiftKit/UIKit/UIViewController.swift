//
//  UIViewController.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)

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

  @objc open var topMostViewController: UIViewController? {
    if let presentedViewController {
      return presentedViewController.topMostViewController
    }
    return self
  }

  public func show(on presentingViewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
    presentingViewController.present(self, animated: animated, completion: completion)
  }

  public func show(animated: Bool, completion: (() -> Void)?) {
    UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
  }

  public func showDetail(_ detailViewController: UIViewController, sender: Any?) {
    showDetailViewController(detailViewController, sender: sender)
  }

  public func dismissOrPopFromNavigationStack(animated: Bool, completion: (() -> Void)? = nil) {
    if let navigationController, navigationController.viewControllers.first !== self {
      navigationController.popViewController(animated: animated, completion: completion)
    } else {
      dismiss(animated: animated, completion: completion)
    }
  }

  public static var embeddingInNavigationControllerHandler: ((UIViewController) -> UINavigationController)?

  public func embeddingInNavigationController(inheritModalBehavior: Bool = true) -> UINavigationController {
    let navigationController = Self.embeddingInNavigationControllerHandler?(self) ?? UINavigationController(rootViewController: self)
    if inheritModalBehavior {
      navigationController.modalTransitionStyle = modalTransitionStyle
      navigationController.modalPresentationStyle = modalPresentationStyle
      navigationController.modalPresentationCapturesStatusBarAppearance = modalPresentationCapturesStatusBarAppearance
      if #available(iOS 13.0, *) {
        navigationController.isModalInPresentation = isModalInPresentation
      }
    }
    return navigationController
  }
}

#endif
