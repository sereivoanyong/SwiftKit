//
//  ShadowView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 2/4/25.
//

import UIKit
import SwiftKit

@available(iOS 13.0, *)
open class ShadowView: CornerView {

  weak open var anchoringView: UIView?

  open var fillColor: UIColor = .systemBackground {
    didSet {
      setNeedsDisplay()
    }
  }

  open var shadowCornerStyle: CornerStyle? {
    didSet {
      setNeedsDisplay()
    }
  }

  open var shadowPathProvider: ((CGRect) -> CGPath)?

  public override init(frame: CGRect) {
    super.init(frame: frame)

    contentMode = .redraw
    isOpaque = false
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    let rectForShadow = bounds
    if let shadowPathProvider {
      layer.shadowPath = shadowPathProvider(rectForShadow)
    } else {
      let shadowCornerRadius = (shadowCornerStyle ?? cornerStyle).resolvedRadius(with: rectForShadow)
      layer.shadowPath = CGPath(roundedRect: rectForShadow, cornerWidth: shadowCornerRadius, cornerHeight: shadowCornerRadius, transform: nil)
    }
  }

  open override func draw(_ rect: CGRect) {
    assert(!isOpaque)
    guard let context = UIGraphicsGetCurrentContext() else { return }
    let cornerRadius = cornerStyle.resolvedRadius(with: rect)
    let path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
    context.addPath(path)
    context.setFillColor(fillColor.resolvedColor(with: traitCollection).cgColor)
    context.fillPath()
  }
}

extension UIView {

  @available(iOS 13.0, *)
  @discardableResult
  public func addShadowView(anchorTo targetView: UIView?, insets: NSDirectionalEdgeInsets = .zero, cornerStyle: CornerStyle? = nil) -> ShadowView {
    let shadowView = ShadowView()
    if let targetView {
      shadowView.anchoringView = targetView
      if let cornerStyle {
        shadowView.cornerStyle = cornerStyle
      }
      insertSubview(shadowView, belowSubview: targetView)
    } else {
      addSubview(shadowView)
    }

    shadowView.translatesAutoresizingMaskIntoConstraints = false
    shadowView.directionalAnchors.constraints(equalTo: (targetView ?? self).directionalAnchors, constants: insets).activate()
    return shadowView
  }
}
