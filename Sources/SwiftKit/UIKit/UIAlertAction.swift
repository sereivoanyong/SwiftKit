//
//  UIAlertAction.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

// https://github.com/nst/iOS-Runtime-Headers/blob/master/PrivateFrameworks/UIKitCore.framework/UIAlertAction.h
extension UIAlertAction {

  // https://github.com/nst/iOS-Runtime-Headers/blob/master/PrivateFrameworks/UIKitCore.framework/_UIAlertControllerActionView.h
  public var _representer: UIView? {
    get { return value(forKey: "_representer") as? UIView }
    set { setValue(newValue, forKey: "_representer") }
  }

  public var _representerLabel: UILabel? {
    return value(forKeyPath: "_representer._label") as? UILabel
  }

  public var handler: ((UIAlertAction) -> Void)? {
    get { return value(forKey: "handler") as? ((UIAlertAction) -> Void) }
    set { setValue(newValue, forKey: "handler") }
  }

  public var image: UIImage? {
    get { return value(forKey: "image") as? UIImage }
    set { setValue(newValue, forKey: "image") }
  }

  @available(iOS 9.0, *)
  public var imageTintColor: UIColor? {
    get { return value(forKey: "_imageTintColor") as? UIColor }
    set { setValue(newValue, forKey: "_imageTintColor") }
  }

  @available(iOS 9.0, *)
  public var titleTextAlignment: NSTextAlignment {
    get { return NSTextAlignment(rawValue: value(forKey: "_titleTextAlignment") as! Int)! }
    set { setValue(newValue.rawValue as NSNumber, forKey: "_titleTextAlignment") }
  }

  @available(iOS 9.0, *)
  public var titleTextColor: UIColor? {
    get { return value(forKey: "_titleTextColor") as? UIColor }
    set { setValue(newValue, forKey: "_titleTextColor") }
  }

  public var descriptiveText: String? {
    get { return value(forKey: "_descriptiveText") as? String }
    set { setValue(newValue, forKey: "_descriptiveText") }
  }

  public convenience init(title: String?, image: UIImage?, style: Style, handler: ((UIAlertAction) -> Void)? = nil) {
    self.init(title: title, style: style, handler: handler)

    self.image = image
  }
}
