//
//  KeyboardLayoutConstraint.swift
//
//  Created by Sereivoan Yong on 1/5/24.
//

import UIKit

final public class KeyboardLayoutConstraint: NSLayoutConstraint {

  public private(set) var swpped: NSLayoutConstraint!

  public override func awakeFromNib() {
    super.awakeFromNib()

    isActive = false
    guard
      let safeAreaLayoutGuide = firstItem as? UILayoutGuide,
      let view = safeAreaLayoutGuide.owningView,
      let viewController = view.owningViewController else {
      fatalError()
    }
    swpped = viewController.viewKeyboardLayoutGuide.topAnchor.constraint(equalTo: secondAnchor as! NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: constant)
    swpped.isActive = true
  }
}
