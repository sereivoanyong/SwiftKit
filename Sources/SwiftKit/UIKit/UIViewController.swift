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
  final public var isVisible: Bool {
    // @see: http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
    return isViewLoaded && view.window != nil
  }
  
  /// Adds the specified view controller including its view as a child of the current view controller
  final public func addChildIncludingView(_ childViewController: UIViewController, addHandler: (_ view: UIView, _ childView: UIView) -> Void) {
    addChild(childViewController)
    addHandler(view, childViewController.view)
    childViewController.didMove(toParent: self)
  }
  
  /// Removes the view controller including its view from its parent
  final public func removeFromParentIncludingView() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
  @discardableResult
  final public func enableEndEditingOnTap(on view: UIView? = nil) -> UITapGestureRecognizer {
    let view = view ?? self.view!
    view.isUserInteractionEnabled = true
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    tapGestureRecognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGestureRecognizer)
    return tapGestureRecognizer
  }
  
  final public var topMostViewController: UIViewController? {
    if let navigationController = self as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
      return visibleViewController.topMostViewController
      
    } else if let tabBarController = self as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
      return selectedViewController.topMostViewController
      
    } else if let presentedViewController = presentedViewController {
      return presentedViewController.topMostViewController
    }
    
    return self
  }
  
  final public func show(animated: Bool, completion: (() -> Void)?) {
    UIApplication.shared.keyTopMostViewController?.present(self, animated: animated, completion: completion)
  }

  @inlinable
  final public func showDetail(_ detailViewController: UIViewController, sender: Any?) {
    showDetailViewController(detailViewController, sender: sender)
  }
  
  open func embeddingInNavigationController(configurationHandler: ((UINavigationController) -> Void)? = nil) -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: self)
    configurationHandler?(navigationController)
    return navigationController
  }
  
  // MARK: - Layout Convenience
  
  private static var safeAreaLayoutGuide: Void?
  final public var safeAreaLayoutGuide: UILayoutGuide {
    if #available(iOS 11.0, *) {
      return view.safeAreaLayoutGuide
    } else {
      return associatedObject(forKey: &UIViewController.safeAreaLayoutGuide, default: {
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.pinHorizontalAnchors(inside: view)
        layoutGuide.topAnchor.equalTo(topLayoutGuide.bottomAnchor)
        bottomLayoutGuide.topAnchor.equalTo(layoutGuide.bottomAnchor)
        return layoutGuide
      }())
    }
  }
  
  final public var safeAreaTopAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return view.safeAreaLayoutGuide.topAnchor
    } else {
      return topLayoutGuide.bottomAnchor
    }
  }
  
  final public var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return view.safeAreaLayoutGuide.bottomAnchor
    } else {
      return bottomLayoutGuide.topAnchor
    }
  }
  
  final public var safeAreaTopInset: CGFloat {
    if #available(iOS 11.0, *) {
      return view.safeAreaInsets.top
    } else {
      return topLayoutGuide.length
    }
  }
  
  final public var safeAreaBottomInset: CGFloat {
    if #available(iOS 11.0, *) {
      return view.safeAreaInsets.bottom
    } else {
      return bottomLayoutGuide.length
    }
  }
  
  final public var safeAreaFrame: CGRect {
    if #available(iOS 11.0, *) {
      return view.bounds.inset(by: view.safeAreaInsets)
    } else {
      return CGRect(x: 0, y: topLayoutGuide.length, width: view.bounds.width, height: bottomLayoutGuide.length)
    }
  }
  
  // MARK: - Others
  
  final public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?, in queue: DispatchQueue) {
    queue.async { [unowned self] in
      self.present(viewController, animated: animated, completion: completion)
    }
  }
  
  final public var topPresentedViewController: UIViewController? {
    var currentPresentedViewController = presentedViewController
    while let presentedViewController = currentPresentedViewController?.presentedViewController {
      currentPresentedViewController = presentedViewController
    }
    return currentPresentedViewController
  }
}
#endif
