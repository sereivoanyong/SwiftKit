//
//  UIView+Background.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIView {
  
  @discardableResult
  @inlinable final public func addBackgroundView(backgroundColor: UIColor) -> UIView {
    return addBackgroundView(UIView.self) { backgroundView in
      backgroundView.backgroundColor = backgroundColor
    }
  }
  
  @discardableResult
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
