//
//  UIAlertController.swift
//
//  Created by Sereivoan Yong on 2/1/18.
//

#if canImport(UIKit)
import UIKit

extension UIAlertController {
  
  final public var contentViewController: UIViewController? {
    get { return value(forKey: "contentViewController") as? UIViewController }
    set { setValue(newValue, forKey: "contentViewController") }
  }
  
  final public var dimmingView: UIView? {
    return value(forKey: "dimmingView") as? UIView
  }
  
  final public var foregroundView: UIView? {
    return value(forKey: "_foregroundView") as? UIView
  }
  
  final public var attributedTitle: NSAttributedString? {
    get { return valueIfResponds(forKey: "_attributedTitle") as? NSAttributedString }
    set { performIfResponds(Selector(("_setAttributedTitle:")), with: newValue) }
  }
  
  final public var attributedMessage: NSAttributedString? {
    get { return valueIfResponds(forKey: "_attributedMessage") as? NSAttributedString }
    set { performIfResponds(Selector(("_setAttributedMessage:")), with: newValue) }
  }
  
  final public var attributedDetailMessage: NSAttributedString? {
    get { return valueIfResponds(forKey: "_attributedDetailMessage") as? NSAttributedString }
    set { performIfResponds(Selector(("_setAttributedDetailMessage:")), with: newValue) }
  }
  
  @discardableResult
  @inlinable public func addAction(title: String?, image: UIImage? = nil, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    let action = UIAlertAction(title: title, image: image, style: style, handler: handler)
    addAction(action)
    return action
  }
  
  @discardableResult
  final public func addTextField() -> UITextField {
    var textField: UITextField!
    addTextField { textField = $0 }
    return textField
  }
  
  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    // Bug fix for "UIAlertController:supportedInterfaceOrientations was invoked recursively!"
    if let topViewController = (presentingViewController as? UINavigationController)?.topViewController, !topViewController.isBeingDismissed {
      return topViewController.supportedInterfaceOrientations
    }
    return super.supportedInterfaceOrientations
  }
  
  public convenience init(title: String?, message: String?, preferredStyle: Style, cancelActionTitle: String?, cancelActionHandler: ((UIAlertAction) -> Void)? = nil) {
    self.init(title: title, message: message, preferredStyle: preferredStyle)
    
    addAction(title: cancelActionTitle, style: .cancel, handler: cancelActionHandler)
  }
}

extension UIViewController {
  
  public static var alertControllerProvider: (String?, String?) -> UIAlertController = { title, message in
    return UIAlertController(title: title, message: message, preferredStyle: .alert)
  }
  
  @inlinable public func presentAlert(title: String?, message: String?, cancelActionTitle: String, cancelActionHandler: ((UIAlertAction) -> Void)? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
    let alertController = type(of: self).alertControllerProvider(title, message)
    alertController.addAction(title: cancelActionTitle, style: .cancel, handler: cancelActionHandler)
    present(alertController, animated: animated, completion: completion)
  }
}
#endif
