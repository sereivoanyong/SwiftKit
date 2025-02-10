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

  public override init(frame: CGRect) {
    super.init(frame: frame)

    contentMode = .redraw
    isOpaque = false
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    let shadowCornerRadius = (shadowCornerStyle ?? cornerStyle).resolvedRadius(with: bounds)
    let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowCornerRadius).cgPath
    layer.setShadow(opacity: 0.15, offset: .zero, radius: 4, path: shadowPath)
    layerShadowColor = .label
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    let bounds = bounds
    let shadowCornerRadius = (shadowCornerStyle ?? cornerStyle).resolvedRadius(with: bounds)
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowCornerRadius).cgPath
  }

  open override func draw(_ rect: CGRect) {
    assert(!isOpaque)
    fillColor.setFill()
    let shadowCornerRadius = (shadowCornerStyle ?? cornerStyle).resolvedRadius(with: rect)
    let path = UIBezierPath(roundedRect: rect, cornerRadius: shadowCornerRadius)
    path.fill()
  }
}

extension UIView {

  @available(iOS 13.0, *)
  @discardableResult
  public func addShadowView(anchorTo targetView: UIView?, insets: NSDirectionalEdgeInsets = .zero, cornerStyle: ShadowView.CornerStyle? = nil) -> ShadowView {
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
