//
//  UIAlertController.swift
//
//  Created by Sereivoan Yong on 2/1/18.
//

import UIKit

extension UIAlertController {

  public var contentViewController: UIViewController? {
    get { return value(forKey: "contentViewController") as? UIViewController }
    set { setValue(newValue, forKey: "contentViewController") }
  }

  public var dimmingView: UIView? {
    return value(forKey: "dimmingView") as? UIView
  }

  public var foregroundView: UIView? {
    return value(forKey: "_foregroundView") as? UIView
  }

  public var attributedTitle: NSAttributedString? {
    get { return valueIfResponds(forKey: "_attributedTitle") as? NSAttributedString }
    set { performIfResponds(Selector(("_setAttributedTitle:")), with: newValue) }
  }

  public var attributedMessage: NSAttributedString? {
    get { return valueIfResponds(forKey: "_attributedMessage") as? NSAttributedString }
    set { performIfResponds(Selector(("_setAttributedMessage:")), with: newValue) }
  }

  public var attributedDetailMessage: NSAttributedString? {
    get { return valueIfResponds(forKey: "_attributedDetailMessage") as? NSAttributedString }
    set { performIfResponds(Selector(("_setAttributedDetailMessage:")), with: newValue) }
  }

  public convenience init(title: String?, message: String?, preferredStyle: Style, cancelActionTitle: String?, cancelActionHandler: ((UIAlertAction) -> Void)? = nil) {
    self.init(title: title, message: message, preferredStyle: preferredStyle)

    addAction(title: cancelActionTitle, style: .cancel, handler: cancelActionHandler)
  }

  @discardableResult @inlinable
  public func addAction(title: String?, image: UIImage? = nil, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    let action = UIAlertAction(title: title, image: image, style: style, handler: handler)
    addAction(action)
    return action
  }

  @discardableResult
  public func addTextField() -> UITextField {
    var textField: UITextField!
    addTextField { textField = $0 }
    return textField
  }

  // MARK: Presentation on Window

  private static let swizzlerForWindowPresentation: Void = {
    class_exchangeInstanceMethodImplementations(UIAlertController.self, #selector(viewDidDisappear(_:)), #selector(_window_viewDidDisappear(_:)))
  }()

  @objc private func _window_viewDidDisappear(_ animated: Bool) {
    _window_viewDidDisappear(animated)

    window?.isHidden = true
    window = nil
  }

  private static var windowKey: Void?
  private var window: UIWindow? {
    get { return associatedObject(forKey: &Self.windowKey, with: self) }
    set { setAssociatedObject(newValue, forKey: &Self.windowKey, with: self) }
  }

  /// - See: https://stackoverflow.com/a/30941356/11235826
  @available(iOS 13.0, macCatalyst 13.1, *)
  public func show(on scene: UIScene? = nil, animated: Bool, completion: (() -> Void)? = nil) {
    guard let windowScene = scene as? UIWindowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      print("Scene is not provided and application has no connected scenes.")
      return
    }
    _ = Self.swizzlerForWindowPresentation

    let window = UIWindow(windowScene: windowScene)
    self.window = window

    if let topWindow = windowScene.windows.dropLast().last {
      window.windowLevel = topWindow.windowLevel + 1
    }

    if let delegate = windowScene.delegate as? UIWindowSceneDelegate, let window = delegate.window ?? nil {
      window.tintColor = window.tintColor
    }

    let rootViewController = UIViewController()
    window.rootViewController = rootViewController

    window.makeKeyAndVisible()
    show(on: rootViewController, animated: animated, completion: completion)
  }
}

extension UIViewController {

  public static var alertControllerProvider: (String?, String?) -> UIAlertController = { title, message in
    return UIAlertController(title: title, message: message, preferredStyle: .alert)
  }

  @inlinable
  public func showAlert(title: String?, message: String?, cancelActionTitle: String, cancelActionHandler: ((UIAlertAction) -> Void)? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
    let alertController = type(of: self).alertControllerProvider(title, message)
    alertController.addAction(title: cancelActionTitle, style: .cancel, handler: cancelActionHandler)
    present(alertController, animated: animated, completion: completion)
  }
}
