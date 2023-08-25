//
//  VisualEffectView.swift
//
//  Created by Sereivoan Yong on 5/2/21.
//

#if os(iOS)

import UIKit

@available(iOS 10.0, *)
open class VisualEffectView: UIVisualEffectView {

  private var animator: UIViewPropertyAnimator!

  open var blurRadius: CGFloat {
    get { return animator.fractionComplete }
    set { animator.fractionComplete = newValue }
  }

  public init(effect: UIVisualEffect, blurRadius: CGFloat) {
    super.init(effect: nil)

    animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
    defer {
      self.blurRadius = blurRadius
    }
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError()
  }
}

#endif
