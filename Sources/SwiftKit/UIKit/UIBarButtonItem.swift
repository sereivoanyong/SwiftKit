//
//  UIBarButtonItem.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

import UIKit

extension UIBarButtonItem {

  @inlinable
  public convenience init(systemItem: SystemItem, target: AnyObject?, action: Selector?) {
    self.init(barButtonSystemItem: systemItem, target: target, action: action)
  }

  @available(iOS, obsoleted: 14.0)
  public static func fixedSpace(_ width: CGFloat) -> Self {
    let barButtonItem = Self(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    barButtonItem.width = width
    return barButtonItem
  }

  @available(iOS, obsoleted: 14.0)
  public static func flexibleSpace() -> Self {
    return Self(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  }

  public var view: UIView? {
    get { return value(forKey: "view") as? UIView }
    set { setValue(newValue, forKey: "view") }
  }

  // MARK: Action Support

  public convenience init(image: UIImage?, style: Style, primaryAction: Action?) {
    self.init(image: image, style: style, target: nil, action: nil)
    bc.primaryAction = primaryAction
  }

  public convenience init(title: String?, style: Style, primaryAction: Action?) {
    self.init(title: title, style: style, target: nil, action: nil)
    bc.primaryAction = primaryAction
  }

  public convenience init(systemItem: SystemItem, primaryAction: Action?) {
    self.init(systemItem: systemItem, target: nil, action: nil)
    bc.primaryAction = primaryAction
  }

  @available(*, deprecated, message: "Use `bc.primaryAction` instead.")
  public var _primaryAction: Action? {
    get { return bc.primaryAction }
    set { bc.primaryAction = newValue }
  }
}

private var primaryActionKey: Void?
extension BackwardCompatibility where Base: UIBarButtonItem {

  public var primaryAction: Action? {
    get { return associatedObject(forKey: &primaryActionKey, with: base) }
    nonmutating set {
      let oldValue = primaryAction
      guard newValue !== oldValue else {
        return
      }
      base.target = newValue
      base.action = #selector(Action.performAction(_:))
      base.title = newValue?.title
      base.image = newValue?.image
      setAssociatedObject(newValue, forKey: &primaryActionKey, with: base)
    }
  }
}
