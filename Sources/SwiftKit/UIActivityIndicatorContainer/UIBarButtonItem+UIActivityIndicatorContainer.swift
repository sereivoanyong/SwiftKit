//
//  UIBarButtonItem+UIActivityIndicatorContainer.swift
//  TongTin
//
//  Created by Sereivoan Yong on 7/3/22.
//

import UIKit

private var titleTextAttributesBeforeActivityIndicatorKey: Void?

extension UIBarButtonItem: UIActivityIndicatorContainer {

  public var defaultActivityIndicatorUserInteractionLevel: ActivityIndicatorUserInteractionLevel {
    return .none // .window()
  }

  public private(set) var titleTextAttributesBeforeActivityIndicator: [NSAttributedString.Key: Any]? {
    get { return associatedValue(forKey: &titleTextAttributesBeforeActivityIndicatorKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &titleTextAttributesBeforeActivityIndicatorKey, with: self) }
  }

  public var containerViewForActivityIndicator: UIView? {
    guard let view = value(forKey: "view") as? UIView else { // _UIButtonBarButton
      return nil
    }
    if let button = view.subviews.first as? UIButton { // _UIModernBarButton
      return button
    }
    return view
  }

  public func willShowActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView) {
    let titleTextAttributes = titleTextAttributes(for: .normal)
    titleTextAttributesBeforeActivityIndicator = titleTextAttributes
    var newTitleTextAttributes = titleTextAttributes ?? [:]
    newTitleTextAttributes[.foregroundColor] = UIColor.clear
    setTitleTextAttributes(newTitleTextAttributes, for: .normal)
  }

  public func willHideActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView) {
    setTitleTextAttributes(titleTextAttributesBeforeActivityIndicator, for: .normal)
    titleTextAttributesBeforeActivityIndicator = nil
  }
}
