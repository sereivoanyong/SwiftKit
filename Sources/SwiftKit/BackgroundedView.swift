//
//  BackgroundedView.swift
//
//  Created by Sereivoan Yong on 8/22/20.
//

import UIKit

public protocol BackgroundedView: AnyObject {
  
  var backgroundView: UIView? { get set }
}

private var kBackgroundViewKey: Void?

extension BackgroundedView where Self: UIView {
  
  public var backgroundView: UIView? {
    get { return associatedObject(forKey: &kBackgroundViewKey, with: self) }
    set {
      if let oldValue = associatedObject(forKey: &kBackgroundViewKey, with: self) as UIView? {
        oldValue.removeFromSuperview()
      }
      if let newValue {
        if newValue.translatesAutoresizingMaskIntoConstraints {
          newValue.frame = bounds
          newValue.autoresizingMask = .flexibleSize
          insertSubview(newValue, at: 0)
        } else {
          NSLayoutConstraint.activate([
            newValue.topAnchor.constraint(equalTo: topAnchor),
            newValue.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(equalTo: newValue.bottomAnchor),
            trailingAnchor.constraint(equalTo: newValue.trailingAnchor)
          ])
        }
      }
      setAssociatedObject(newValue, forKey: &kBackgroundViewKey, with: self)
    }
  }
}
