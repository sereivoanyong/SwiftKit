//
//  BarShadowView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 5/19/25.
//

import UIKit
import SwiftKit

open class BarShadowView: UIImageView {

  open class var defaultColor: UIColor {
    // @see: https://github.com/noahsark769/ColorCompatibility/blob/master/ColorCompatibility.swift
    if #available(iOS 13, *) {
      return .opaqueSeparator
    } else {
      return .decimal(red: 198, green: 198, blue: 200, alpha: 1)
    }
  }

  open var axis: NSLayoutConstraint.Axis = .horizontal {
    didSet {
      updateCompressionResistance()
    }
  }

  @IBInspectable
  public var isVertical: Bool {
    get { return axis.isVertical }
    set { axis.isVertical = newValue }
  }

  open var thickness: CGFloat = -1

  open override var backgroundColor: UIColor? {
    get { return super.backgroundColor }
    set { super.backgroundColor = newValue ?? Self.defaultColor }
  }

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)

    backgroundColor = Self.defaultColor
    isUserInteractionEnabled = false
    updateCompressionResistance()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  open override func awakeFromNib() {
    super.awakeFromNib()

    if backgroundColor == nil {
      backgroundColor = Self.defaultColor
    }
    assert(!isUserInteractionEnabled)
    updateCompressionResistance()
  }

  private func updateCompressionResistance() {
    switch axis {
    case .horizontal:
      setContentCompressionResistancePriority(.required, for: .vertical)
      setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    case .vertical:
      setContentCompressionResistancePriority(.required, for: .horizontal)
      setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    @unknown default:
      setContentCompressionResistancePriority(.required, for: .vertical)
      setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
  }

  private func resolvedThickness() -> CGFloat {
    return thickness < 0 ? traitCollection.displayPointPerPixel : thickness
  }

  open override var intrinsicContentSize: CGSize {
    let resolvedThickness = resolvedThickness()
    switch axis {
    case .horizontal:
      return CGSize(width: UIView.noIntrinsicMetric, height: resolvedThickness)
    case .vertical:
      return CGSize(width: resolvedThickness, height: UIView.noIntrinsicMetric)
    @unknown default:
      return CGSize(width: UIView.noIntrinsicMetric, height: resolvedThickness)
    }
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    var size = super.sizeThatFits(size)
    let resolvedThickness = resolvedThickness()
    switch axis {
    case .horizontal:
      size.width = resolvedThickness
    case .vertical:
      size.height = resolvedThickness
    @unknown default:
      size.width = resolvedThickness
    }
    return size
  }
}

private var barShadowViewKey: Void?

extension SYCompatibility where Base: UIView {

  public var barShadowView: BarShadowView? {
    return associatedObject(forKey: &barShadowViewKey, with: base) as BarShadowView?
  }

  public func removeBarShadowView() {
    barShadowView?.removeFromSuperview()
    removeAssociatedObject(forKey: &barShadowViewKey, with: base)
  }

  @discardableResult
  public func addBarShadowView(thickness: CGFloat = -1, color: UIColor? = nil, for barPosition: BarPosition, layoutGuide: LayoutGuide? = nil, insets: DirectionalEdgeInsets = .zero) -> BarShadowView {
    assert(!base.clipsToBounds)
    removeBarShadowView()
    
    let barShadowView = BarShadowView()
    let axis: NSLayoutConstraint.Axis
    switch barPosition {
    case .top, .bottom:
      axis = .horizontal
    case .leading, .trailing:
      axis = .vertical
    }
    barShadowView.axis = axis
    barShadowView.thickness = thickness
    barShadowView.backgroundColor = color
    setAssociatedObject(barShadowView, forKey: &barShadowViewKey, with: base)
    base.addSubview(barShadowView)

    barShadowView.translatesAutoresizingMaskIntoConstraints = false
    let layoutGuide = layoutGuide ?? base
    let constraints: [NSLayoutConstraint]
    switch barPosition {
    case .top:
      constraints = [
        barShadowView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.leading),
        barShadowView.topAnchor.constraint(equalTo: base.bottomAnchor, constant: insets.bottom),
        layoutGuide.trailingAnchor.constraint(equalTo: barShadowView.trailingAnchor, constant: insets.trailing),
      ]
    case .leading:
      constraints = [
        barShadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
        layoutGuide.bottomAnchor.constraint(equalTo: barShadowView.bottomAnchor, constant: insets.bottom),
        barShadowView.leadingAnchor.constraint(equalTo: base.trailingAnchor, constant: insets.trailing),
      ]
    case .bottom:
      constraints = [
        base.topAnchor.constraint(equalTo: barShadowView.bottomAnchor, constant: insets.top),
        barShadowView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.leading),
        layoutGuide.trailingAnchor.constraint(equalTo: barShadowView.trailingAnchor, constant: insets.trailing),
      ]
    case .trailing:
      constraints = [
        barShadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
        base.leadingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: insets.leading),
        layoutGuide.bottomAnchor.constraint(equalTo: barShadowView.bottomAnchor, constant: insets.bottom),
      ]
    }
    NSLayoutConstraint.activate(constraints)
    return barShadowView
  }
}
