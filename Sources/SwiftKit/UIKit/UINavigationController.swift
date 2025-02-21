//
//  UINavigationController.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)

import UIKit

extension UINavigationController {

  public var rootViewController: UIViewController? {
    return viewControllers.first
  }

  public override var topMostViewController: UIViewController? {
    if let visibleViewController {
      return visibleViewController.topMostViewController
    }
    return super.topMostViewController
  }

  @objc(navigationBar:shouldPopItem:)
  open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
    if viewControllers.count < navigationBar.items!.count {
      return true
    }
    let shouldPop = item.shouldPopHandler?() ?? true
    if shouldPop {
      DispatchQueue.main.async { [unowned self] in
        popViewController(animated: true)
      }
    } else {
      // Prevent the back button from staying in an disabled state
      for view in navigationBar.subviews {
        if view.alpha < 1.0 {
          UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 1.0
          })
        }
      }
    }
    return false
  }

  public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
    pushViewController(viewController, animated: animated)
    if let completion {
      if animated, let coordinator = transitionCoordinator {
        coordinator.animate(alongsideTransition: nil) { _ in
          completion()
        }
      } else {
        completion()
      }
    }
  }

  @discardableResult
  public func popViewController(animated: Bool, completion: (() -> Void)?) -> UIViewController? {
    let poppedViewController = popViewController(animated: animated)
    if let completion {
      if animated, let coordinator = transitionCoordinator {
        coordinator.animate(alongsideTransition: nil) { _ in
          completion()
        }
      } else {
        completion()
      }
    }
    return poppedViewController
  }

  @discardableResult
  public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) -> [UIViewController]? {
    let poppedViewControllers = popToViewController(viewController, animated: animated)
    if let completion {
      if animated, let coordinator = transitionCoordinator {
        coordinator.animate(alongsideTransition: nil) { _ in
          completion()
        }
      } else {
        completion()
      }
    }
    return poppedViewControllers
  }

  @discardableResult
  public func popToViewController(at index: Int, animated: Bool, completion: (() -> Void)? = nil) -> [UIViewController]? {
    popToViewController(viewControllers[index], animated: animated, completion: completion)
  }

  @discardableResult
  public func popToRootViewController(animated: Bool, completion: (() -> Void)?) -> [UIViewController]? {
    let poppedViewControllers = popToRootViewController(animated: animated)
    if let completion {
      if animated, let coordinator = transitionCoordinator {
        coordinator.animate(alongsideTransition: nil) { _ in
          completion()
        }
      } else {
        completion()
      }
    }
    return poppedViewControllers
  }

  public func setTopViewController(_ topViewController: UIViewController, animated: Bool) {
    var newViewControllers = viewControllers
    if !newViewControllers.isEmpty {
      newViewControllers.removeLast()
    }
    newViewControllers.append(topViewController)
    setViewControllers(newViewControllers, animated: animated)
  }
}

#endif
