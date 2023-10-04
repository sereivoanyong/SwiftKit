//
//  BCBackgroundView.swift
//
//  Created by Sereivoan Yong on 10/4/23.
//

import UIKit

open class BCBackgroundView: UIView {

  open var configuration: BCBackgroundConfiguration {
    didSet {
      setNeedsDisplay()
    }
  }

  public init(configuration: BCBackgroundConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    isUserInteractionEnabled = false
    clipsToBounds = true
    isOpaque = false
  }

  public required init?(coder: NSCoder) {
    self.configuration = .init()
    super.init(coder: coder)
    assert(!isUserInteractionEnabled)
    assert(!clipsToBounds)
    assert(!isOpaque)
    assert(clearsContextBeforeDrawing)
  }

  open override func draw(_ rect: CGRect) {
    let rect = bounds.inset(by: configuration.backgroundInsets.resolved(with: effectiveUserInterfaceLayoutDirection))
    let path: UIBezierPath
    if configuration.cornerRadius > 0 {
      path = UIBezierPath(
        roundedRect: bounds,
        byRoundingCorners: configuration.maskedCorners,
        cornerRadii: CGSize(width: configuration.cornerRadius, height: configuration.cornerRadius)
      )
    } else {
      path = UIBezierPath(rect: rect)
    }
    configuration.resolvedBackgroundColor(for: tintColor).setFill()
    path.fill()
  }
}
