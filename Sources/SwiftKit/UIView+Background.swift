//
//  UIView+Background.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

public protocol BackgroundedView: AnyObject {
  
  var backgroundView: UIView? { get set }
}

private var kBackgroundViewKey: Void?

extension BackgroundedView where Self: UIView {
  
  public var backgroundView: UIView? {
    get { associatedObject(forKey: &kBackgroundViewKey) }
    set {
      if let oldValue = associatedObject(forKey: &kBackgroundViewKey) as UIView? {
        oldValue.removeFromSuperview()
      }
      if let newValue = newValue {
        if newValue.translatesAutoresizingMaskIntoConstraints {
          newValue.frame = bounds
          newValue.autoresizingMask = .flexibleSize
          insertSubview(newValue, at: 0)
        } else {
          newValue.pinAnchors(inside: self)
        }
      }
      setAssociatedObject(newValue, forKey: &kBackgroundViewKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UIView {
  
  final public func addBackgroundView(backgroundColor: UIColor, below subview: UIView? = nil) {
    let backgroundView = UIView()
    backgroundView.backgroundColor = backgroundColor
    addBackgroundView(backgroundView, below: subview)
  }
  
  final public func addBackgroundView(_ backgroundView: UIView, below subview: UIView? = nil) {
    let insertTo: (UIView) -> Void = { view in
      if let subview = subview {
        view.insertSubview(backgroundView, belowSubview: subview)
      } else {
        view.insertSubview(backgroundView, at: 0)
      }
    }
    if backgroundView.translatesAutoresizingMaskIntoConstraints {
      backgroundView.frame = bounds
      backgroundView.autoresizingMask = .flexibleSize
      insertTo(self)
    } else {
      insertTo(self)
      backgroundView.pinAnchors(inside: self)
    }
  }
  
  @discardableResult @available(*, deprecated)
  @inlinable final public func addBackgroundView<T>(_ backgroundViewClass: T.Type, below subview: UIView? = nil, configurationHandler: (T) -> Void) -> T where T: UIView {
    let backgroundView = backgroundViewClass.init(frame: bounds)
    backgroundView.autoresizingMask = .flexibleSize
    if let subview = subview {
      insertSubview(backgroundView, belowSubview: subview)
    } else {
      insertSubview(backgroundView, at: 0)
    }
    return backgroundView
  }
}
#endif
