//
//  UIStackView.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UIStackView {

  @inlinable
  public convenience init(arrangedSubviews: [UIView] = [], axis: NSLayoutConstraint.Axis, distribution: Distribution = .fill, alignment: Alignment = .fill, spacing: CGFloat = 0) {
    self.init(frame: .zero)
    self.axis = axis
    self.distribution = distribution
    self.alignment = alignment
    self.spacing = spacing
    addArrangedSubviews(arrangedSubviews)
  }

  /// Adds views to the end of the `arrangedSubviews` array.
  public func addArrangedSubviews(_ views: [UIView]) {
    for view in views {
      addArrangedSubview(view)
    }
  }

  /*
   Removes all arranged subviews without removing them as subviews of the receiver.
   To remove the view as subviews, send it -removeFromSuperview as usual;
   the relevant UIStackView will remove it from its arrangedSubviews list
   automatically.
   */
  public func removeAllArrangedSubviews() {
    for view in arrangedSubviews.reversed() {
      removeArrangedSubview(view)
    }
  }
}
