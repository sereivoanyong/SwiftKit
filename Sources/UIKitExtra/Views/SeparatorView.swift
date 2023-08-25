//
//  SeparatorView.swift
//
//  Created by Sereivoan Yong on 3/2/21.
//

#if os(iOS)

import UIKit

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
    get { return axis == .vertical }
    set { axis = newValue ? .vertical : .horizontal }
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
#else
  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    commonInit()
  }
#endif

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

  open override var intrinsicContentSize: CGSize {
    if isVertical {
      return CGSize(width: thickness < 0 ? (1 / traitCollection.displayScale) : thickness, height: UIView.noIntrinsicMetric)
    } else {
      return CGSize(width: UIView.noIntrinsicMetric, height: thickness < 0 ? (1 / traitCollection.displayScale) : thickness)
    }
  }
}

#endif
