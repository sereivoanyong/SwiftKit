//
//  UIView+Background.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIView {
  
  public func addBackgroundView(backgroundColor: UIColor, below subview: UIView? = nil) {
    let backgroundView = UIView()
    backgroundView.backgroundColor = backgroundColor
    addBackgroundView(backgroundView, below: subview)
  }
  
  public func addBackgroundView(_ backgroundView: UIView, below subview: UIView? = nil) {
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
      NSLayoutConstraint.activate([
        backgroundView.topAnchor.constraint(equalTo: topAnchor),
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
        bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
        trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
      ])
    }
  }
}
#endif
