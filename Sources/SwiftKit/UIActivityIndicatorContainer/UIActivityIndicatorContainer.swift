//
//  UIActivityIndicatorContainer.swift
//  TongTin
//
//  Created by Sereivoan Yong on 6/28/22.
//

import UIKit

public enum ActivityIndicatorUserInteractionLevel {

  case none

  // Root view of UIViewController if found
  case view(UIView? = nil)

  case window(UIWindow? = nil)
}

public protocol UIActivityIndicatorContainer: NSObjectProtocol {

  var containerViewForActivityIndicator: UIView? { get }

  var activityIndicatorView: UIActivityIndicatorView { get }

  var showsActivityIndicator: Bool  { get set }

  var defaultActivityIndicatorUserInteractionLevel: ActivityIndicatorUserInteractionLevel { get }

  func makeActivityIndicatorView() -> UIActivityIndicatorView

  func makeConstraintsForActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView, in containerView: UIView) -> [NSLayoutConstraint]

  func willShowActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView)

  func willHideActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView)
}

private var activityIndicatorConfigurationHandlerKey: Void?
private var userInteractionLevelKey: Void?
private var activityIndicatorViewKey: Void?

extension UIActivityIndicatorContainer {

  public var activityIndicatorConfigurationHandler: ((UIActivityIndicatorView) -> Void)? {
    get { return associatedValue(forKey: &activityIndicatorConfigurationHandlerKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &activityIndicatorConfigurationHandlerKey, with: self) }
  }

  public var defaultActivityIndicatorUserInteractionLevel: ActivityIndicatorUserInteractionLevel {
    return .none
  }

  public var activityIndicatorUserInteractionLevel: ActivityIndicatorUserInteractionLevel {
    get { return associatedValue(default: defaultActivityIndicatorUserInteractionLevel, forKey: &userInteractionLevelKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &userInteractionLevelKey, with: self) }
  }

  public var activityIndicatorViewIfLoaded: UIActivityIndicatorView? {
    return associatedObject(forKey: &activityIndicatorViewKey, with: self)
  }

  public var activityIndicatorView: UIActivityIndicatorView {
    let activityIndicatorView = activityIndicatorViewIfLoaded ?? {
      let activityIndicatorView = makeActivityIndicatorView()
      setAssociatedObject(activityIndicatorView, forKey: &activityIndicatorViewKey, with: self)
      activityIndicatorConfigurationHandler?(activityIndicatorView)
      return activityIndicatorView
    }()
    if activityIndicatorView.superview == nil, let containerView = containerViewForActivityIndicator {
      activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview(activityIndicatorView)
      let constraints = makeConstraintsForActivityIndicator(activityIndicatorView, in: containerView)
      NSLayoutConstraint.activate(constraints)
    }
    return activityIndicatorView
  }

  public var showsActivityIndicator: Bool {
    get { return activityIndicatorViewIfLoaded?.isAnimating ?? false }
    set {
      let view = activityIndicatorView
      guard newValue != view.isAnimating else {
        return
      }
      if newValue {
        setUserInteractionEnabled(false)
        willShowActivityIndicator(view)
        view.startAnimating()
      } else {
        setUserInteractionEnabled(true)
        willHideActivityIndicator(view)
        view.stopAnimating()
      }
    }
  }

  public func makeActivityIndicatorView() -> UIActivityIndicatorView {
    let activityIndicatorView: UIActivityIndicatorView
    if #available(iOS 13.0, *) {
      activityIndicatorView = UIActivityIndicatorView(style: .medium)
    } else {
      activityIndicatorView = UIActivityIndicatorView(style: .gray)
    }
    activityIndicatorView.hidesWhenStopped = true
    return activityIndicatorView
  }

  public func makeConstraintsForActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView, in containerView: UIView) -> [NSLayoutConstraint] {
    return [
      activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
    ]
  }

  private func setUserInteractionEnabled(_ isUserInteractionEnabled: Bool) {
    switch activityIndicatorUserInteractionLevel {
    case .none:
      break
    case .view(let view):
      if let view {
        view.isUserInteractionEnabled = isUserInteractionEnabled
      } else {
        (self as? UIViewController ?? containerViewForActivityIndicator?.owningViewController)?.view.isUserInteractionEnabled = isUserInteractionEnabled
      }
    case .window(let window):
      (window ?? containerViewForActivityIndicator?.window ?? (self as? UIView)?.window)?.isUserInteractionEnabled = isUserInteractionEnabled
    }
  }
}
