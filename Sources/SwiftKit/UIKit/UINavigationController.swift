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
    if animated, let completion = completion {
      CATransaction.begin()
      CATransaction.setCompletionBlock(completion)
      pushViewController(viewController, animated: animated)
      CATransaction.commit()
    } else {
      pushViewController(viewController, animated: animated)
    }
  }
  
  @discardableResult
  final public func popViewController(animated: Bool, completion: (() -> Void)?) -> UIViewController? {
    let viewController: UIViewController?
    if animated, let completion = completion {
      CATransaction.begin()
      CATransaction.setCompletionBlock(completion)
      viewController = popViewController(animated: animated)
      CATransaction.commit()
    } else {
      viewController = popViewController(animated: animated)
    }
    return viewController
  }
  
  @discardableResult
  final public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) -> [UIViewController]? {
    let viewControllers: [UIViewController]?
    if animated, let completion = completion {
      CATransaction.begin()
      CATransaction.setCompletionBlock(completion)
      viewControllers = popToViewController(viewController, animated: animated)
      CATransaction.commit()
    } else {
      viewControllers = popToViewController(viewController, animated: animated)
    }
    return viewControllers
  }
  
  @discardableResult
  final public func popToRootViewController(animated: Bool, completion: (() -> Void)?) -> [UIViewController]? {
    let viewControllers: [UIViewController]?
    if animated, let completion = completion {
      CATransaction.begin()
      CATransaction.setCompletionBlock(completion)
      viewControllers = popToRootViewController(animated: animated)
      CATransaction.commit()
    } else {
      viewControllers = popToRootViewController(animated: animated)
    }
    return viewControllers
  }
  
  final public func setTopViewController(_ topViewController: UIViewController, animated: Bool) {
    var newViewControllers = viewControllers
    if !newViewControllers.isEmpty {
      newViewControllers.removeLast()
    }
    newViewControllers.append(topViewController)
    setViewControllers(newViewControllers, animated: animated)
  }
  
  public static func swizzleForAppearanceAndRotationMethodsForwarding() {
    class_exchangeInstanceMethodImplementations(self, #selector(viewDidLoad), #selector(_a_viewDidLoad))
    class_exchangeInstanceMethodImplementations(self, #selector(getter: prefersStatusBarHidden), #selector(getter: _a_prefersStatusBarHidden))
    class_exchangeInstanceMethodImplementations(self, #selector(getter: preferredStatusBarStyle), #selector(getter: _a_preferredStatusBarStyle))
    class_exchangeInstanceMethodImplementations(self, #selector(getter: preferredStatusBarUpdateAnimation), #selector(getter: _a_preferredStatusBarUpdateAnimation))
    
    class_exchangeInstanceMethodImplementations(self, #selector(getter: shouldAutorotate), #selector(getter: _r_shouldAutorotate))
    class_exchangeInstanceMethodImplementations(self, #selector(getter: supportedInterfaceOrientations), #selector(getter: _r_supportedInterfaceOrientations))
    class_exchangeInstanceMethodImplementations(self, #selector(getter: preferredInterfaceOrientationForPresentation), #selector(getter: _r_preferredInterfaceOrientationForPresentation))
  }
  
  // Appearances
  
  @objc private func _a_viewDidLoad() {
    _a_viewDidLoad()
    
    if type(of: self) == UINavigationController.self {
      if #available(iOS 13.0, *) {
        view.backgroundColor = .systemBackground
      } else {
        view.backgroundColor = .white
      }
    }
  }
  
  @objc private var _a_prefersStatusBarHidden: Bool {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.prefersStatusBarHidden
    }
    return self._a_prefersStatusBarHidden
  }
  
  @objc private var _a_preferredStatusBarStyle: UIStatusBarStyle {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.preferredStatusBarStyle
    }
    return self._a_preferredStatusBarStyle
  }
  
  @objc private var _a_preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.preferredStatusBarUpdateAnimation
    }
    return self._a_preferredStatusBarUpdateAnimation
  }
  
  // Rotations
  
  @objc private var _r_shouldAutorotate: Bool {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.shouldAutorotate
    }
    return self._r_shouldAutorotate
  }
  
  @objc private var _r_supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.supportedInterfaceOrientations
    }
    return self._r_supportedInterfaceOrientations
  }
  
  @objc private var _r_preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    if let lastViewController = viewControllers.last, !lastViewController.isBeingDismissed {
      return lastViewController.preferredInterfaceOrientationForPresentation
    }
    return self._r_preferredInterfaceOrientationForPresentation
  }
  
  /*
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
   */
}
#endif
