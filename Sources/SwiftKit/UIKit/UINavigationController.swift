//
//  UINavigationController.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UINavigationController {
  
  final public var rootViewController: UIViewController? {
    return viewControllers.first
  }
  
  public convenience init(navigationBarClass: UINavigationBar.Type? = nil, toolbarClass: UIToolbar.Type? = nil, rootViewController: UIViewController) {
    self.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    
    viewControllers = [rootViewController]
  }
  
  @objc(navigationBar:shouldPopItem:)
  open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
    if viewControllers.count < navigationBar.items!.count {
      return true
    }
    let shouldPop = item.shouldPopHandler?() ?? true
    if shouldPop {
      DispatchQueue.main.async { [unowned self] in
        self.popViewController(animated: true)
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
  
  final public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
    if let completion = completion {
      if animated {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
      } else {
        pushViewController(viewController, animated: animated)
        completion()
      }
    } else {
      pushViewController(viewController, animated: animated)
    }
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }
  }
  
  open override var transitionCoordinator: UIViewControllerTransitionCoordinator? {
    guard let transitionCoordinator = super.transitionCoordinator else {
      return nil
    }
    if transitionCoordinator.viewController(forKey: .to) == topViewController {
      transitionCoordinator.containerView.backgroundColor = view.backgroundColor
    } else {
      transitionCoordinator.containerView.backgroundColor = .clear
    }
    return transitionCoordinator
  }
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.preferredStatusBarStyle
    }
    return super.preferredStatusBarStyle
  }
  
  open override var shouldAutorotate: Bool {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.shouldAutorotate
    }
    return super.shouldAutorotate
  }
  
  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.supportedInterfaceOrientations
    }
    return super.supportedInterfaceOrientations
  }
  
  open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.preferredInterfaceOrientationForPresentation
    }
    return super.preferredInterfaceOrientationForPresentation
  }
  
  open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.preferredStatusBarUpdateAnimation
    }
    return super.preferredStatusBarUpdateAnimation
  }
  
  open override var previewActionItems: [UIPreviewActionItem] {
    return topViewController?.previewActionItems ?? super.previewActionItems
  }
}
#endif
