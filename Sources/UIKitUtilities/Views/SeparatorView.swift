//
//  SeparatorView.swift
//
//  Created by Sereivoan Yong on 3/2/21.
//

import UIKit
import SwiftKit

@IBDesignable
open class SeparatorView: UIView {

  public static var defaultBackgroundColor: UIColor = {
    if #available(iOS 13.0, *) {
      return .separator
    } else {
      return UIColor(red: 60/255.0, green: 60/255.0, blue: 67/255.0, alpha: 0.29)
    }
  }()

  // Axis is not marked as frozen. Instead, `isVertical` is widely used.
  open var axis: NSLayoutConstraint.Axis = .horizontal

  @IBInspectable
  public var isVertical: Bool {
    get { return axis.isVertical }
    set { axis.isVertical = newValue }
  }

  // Set to nil to use default.
  open override var backgroundColor: UIColor? {
    get { return super.backgroundColor }
    set { super.backgroundColor = newValue ?? Self.defaultBackgroundColor }
  }

  // Negative (-1 preferred) means (1 / display scale)
  // 0 means invisible
  @IBInspectable
  open var thickness: CGFloat = -1 {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

#if TARGET_INTERFACE_BUILDER
  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    commonInit()
  }
#endif

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
#if !TARGET_INTERFACE_BUILDER
    commonInit()
#endif
  }


  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    // Check if values are not set by interface builder
    if backgroundColor == nil {
      backgroundColor = Self.defaultBackgroundColor
    }
    if contentCompressionResistancePriority(for: .horizontal) == .defaultHigh {
      setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
    }
    if contentCompressionResistancePriority(for: .vertical) == .defaultHigh {
      setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
    }
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let resolvedThickness = thickness < 0 ? traitCollection.displayPointPerPixel : thickness
    if isVertical {
      return CGSize(width: resolvedThickness, height: 0)
    } else {
      return CGSize(width: 0, height: resolvedThickness)
    }
  }

  open override var intrinsicContentSize: CGSize {
    let resolvedThickness = thickness < 0 ? traitCollection.displayPointPerPixel : thickness
    if isVertical {
      return CGSize(width: resolvedThickness, height: UIView.noIntrinsicMetric)
    } else {
      return CGSize(width: UIView.noIntrinsicMetric, height: resolvedThickness)
    }
  }
}

extension UIView {

  fileprivate static var defaultShadowColor: UIColor {
    // @see: https://github.com/noahsark769/ColorCompatibility/blob/master/ColorCompatibility.swift
    if #available(iOS 13, *) {
      return .separator
    } else {
      return .decimal(red: 60, green: 60, blue: 67, alpha: 0.29)
    }
  }

  private static var shadowViewsKey: Void?

  public fileprivate(set) var shadowViews: [CGRectEdge: UIView] {
    get { return associatedValue(default: [:], forKey: &Self.shadowViewsKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &Self.shadowViewsKey, with: self) }
  }

  @discardableResult
  public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, thickness: CGFloat = UIScreen.main.pointPerPixel) -> UIView {
    assert(shadowViews[edge] == nil, "Existing shadow view at \(edge) edge found.")
    let frame: CGRect
    let autoresizingMask: UIView.AutoresizingMask
    switch edge {
    case .minXEdge:
      frame = CGRect(x: clipsToBounds ? 0 : -thickness, y: 0, width: thickness, height: bounds.size.height)
      autoresizingMask = .flexibleHeight

    case .maxXEdge:
      frame = CGRect(x: clipsToBounds ? (bounds.size.width - thickness) : bounds.size.width, y: 0, width: thickness, height: bounds.size.height)
      autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]

    case .minYEdge:
      frame = CGRect(x: 0, y: clipsToBounds ? 0 : -thickness, width: bounds.size.width, height: thickness)
      autoresizingMask = .flexibleWidth

    case .maxYEdge:
      frame = CGRect(x: 0, y: clipsToBounds ? (bounds.size.height - thickness) : bounds.size.height, width: bounds.size.width, height: thickness)
      autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }
    let shadowView = UIView(frame: frame)
    shadowView.autoresizingMask = autoresizingMask
    shadowView.backgroundColor = color ?? Self.defaultShadowColor
    addSubview(shadowView)
    shadowViews[edge] = shadowView
    return shadowView
  }

  @discardableResult
  public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, thickness: CGFloat = UIScreen.main.pointPerPixel, target: LayoutGuide? = nil, layoutGuide: LayoutGuide, inset: UIEdgeInsets = .zero) -> UIView {
    assert(shadowViews[edge] == nil, "Existing shadow view at \(edge) edge found.")
    let shadowView = UIView()
    shadowView.backgroundColor = color ?? Self.defaultShadowColor
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(shadowView)

    let target = target ?? self
    let constraints: [NSLayoutConstraint]
    switch edge {
    case .minXEdge:
      constraints = [
        shadowView.widthAnchor.constraint(equalToConstant: thickness),
        shadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: inset.top),
        layoutGuide.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: inset.bottom),
        (clipsToBounds ? shadowView.leftAnchor.constraint(equalTo: target.leftAnchor) : target.leftAnchor.constraint(equalTo: shadowView.rightAnchor)),
      ]

    case .maxXEdge:
      constraints = [
        shadowView.widthAnchor.constraint(equalToConstant: thickness),
        shadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: inset.top),
        (clipsToBounds ? target.rightAnchor.constraint(equalTo: shadowView.rightAnchor) : shadowView.leftAnchor.constraint(equalTo: target.rightAnchor)),
        layoutGuide.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: inset.bottom),
      ]

    case .minYEdge:
      constraints = [
        shadowView.heightAnchor.constraint(equalToConstant: thickness),
        (clipsToBounds ? shadowView.topAnchor.constraint(equalTo: target.topAnchor) : target.topAnchor.constraint(equalTo: shadowView.bottomAnchor)),
        shadowView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: inset.left),
        layoutGuide.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: inset.right),
      ]

    case .maxYEdge:
      constraints = [
        shadowView.heightAnchor.constraint(equalToConstant: thickness),
        (clipsToBounds ? target.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor) : shadowView.topAnchor.constraint(equalTo: target.bottomAnchor)),
        shadowView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: inset.left),
        layoutGuide.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: inset.right),
      ]
    }
    NSLayoutConstraint.activate(constraints)
    shadowViews[edge] = shadowView
    return shadowView
  }

  @discardableResult
  public func removeShadowView(at edge: CGRectEdge) -> UIView? {
    if let shadowView = shadowViews.removeValue(forKey: edge) {
      shadowView.removeFromSuperview()
      return shadowView
    }
    return nil
  }
}

extension NSObjectProtocol where Self: UIView {

  @discardableResult
  public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, thickness: CGFloat = UIScreen.main.pointPerPixel, constraintsProvider: (Self, UIView) -> [NSLayoutConstraint]) -> UIView {
    assert(shadowViews[edge] == nil, "Existing shadow view at \(edge) edge found.")
    let shadowView = UIView()
    shadowView.backgroundColor = color ?? Self.defaultShadowColor
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(shadowView)
    var constraints = constraintsProvider(self, shadowView)
    switch edge {
    case .minXEdge, .maxXEdge:
      constraints.append(shadowView.widthAnchor.constraint(equalToConstant: thickness))
    case .minYEdge, .maxYEdge:
      constraints.append(shadowView.heightAnchor.constraint(equalToConstant: thickness))
    }
    NSLayoutConstraint.activate(constraints)
    shadowViews[edge] = shadowView
    return shadowView
  }
}
