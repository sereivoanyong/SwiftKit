//
//  BackgroundedView.swift
//
//  Created by Sereivoan Yong on 8/22/20.
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
#endif
