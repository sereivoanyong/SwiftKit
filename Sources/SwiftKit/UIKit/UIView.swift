//
//  UIView.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

extension UIView {

  public var owningViewController: UIViewController? {
    if let next {
      if let viewController = next as? UIViewController {
        return viewController
      }
      if let view = next as? UIView {
        return view.owningViewController
      }
    }
    return nil
  }

  public func viewToResepectLayoutMargins() -> UIView {
    if preservesSuperviewLayoutMargins, let superview {
      return superview.viewToResepectLayoutMargins()
    }
    return self
  }

  /// Returns a snapshot of an entire bounds of the view
  public func snapshot() -> UIImage {
    return UIImage(size: bounds.size, opaque: false, scale: traitCollection.displayScale, actions: layer.render(in:))
  }

  public func sizeThatFits(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
    return sizeThatFits(CGSize(width: width, height: height))
  }

  public var readableContentFrame: CGRect {
    return readableContentGuide.layoutFrame
  }

  public var readableContentInsets: UIEdgeInsets {
    let frame = readableContentGuide.layoutFrame
    return UIEdgeInsets(top: frame.minY, left: frame.minX, bottom: bounds.height - frame.maxY, right: bounds.width - frame.maxX)
  }

  @available(iOS 11.0, *)
  public var safeAreaFrame: CGRect {
    return bounds.inset(by: safeAreaInsets)
  }

  public var safeAreaInsetsIfAvailable: UIEdgeInsets {
    if #available(iOS 11.0, *) {
      return safeAreaInsets
    } else {
      return .zero
    }
  }

  public func addSubviews(_ views: [UIView]) {
    for view in views {
      addSubview(view)
    }
  }

  public func removeSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }

  @discardableResult
  public func addTapGestureRecognizer(handler: @escaping (UITapGestureRecognizer) -> Void, configurationHandler: (UITapGestureRecognizer) -> Void = { _ in }) -> UITapGestureRecognizer {
    isUserInteractionEnabled = true
    let tapGestureRecognizer = UITapGestureRecognizer(handler: handler)
    tapGestureRecognizer.cancelsTouchesInView = false
    configurationHandler(tapGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    return tapGestureRecognizer
  }

  @discardableResult
  public func addTapGestureRecognizerToEndEditing(_ force: Bool = true) -> UITapGestureRecognizer {
    return addTapGestureRecognizer { [unowned self] _ in
      endEditing(force)
    }
  }

  /// Sets the priority with which a view resists being made larger or smaller than its intrinsic size
  public func setContentResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
    setContentHuggingPriority(priority, for: axis)
    setContentCompressionResistancePriority(priority, for: axis)
  }
  
  /// Sets the priority with which a view resists being made larger or smaller than its intrinsic size
  public func setContentResistancePriority(_ priority: UILayoutPriority) {
    setContentResistancePriority(priority, for: .horizontal)
    setContentResistancePriority(priority, for: .vertical)
  }
}

private var layerConfigurationBorderColorKey: Void?
private var layerConfigurationBorderWidthKey: Void?
private var layerShouldRasterizeWithDisplayScaleKey: Void?

extension UIView {

  /// Default is 0.
  @IBInspectable public var layerCornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set { layer.cornerRadius = newValue }
  }

  /// Default is `false`.
  @IBInspectable public var layerContinuousCorners: Bool {
    get { return layer.continuousCorners }
    set { layer.continuousCorners = newValue }
  }

  /// Set to `nil` to use `tintColor`. Default is `nil`.
  @IBInspectable public var layerConfigurationBorderColor: UIColor? {
    get { return associatedObject(forKey: &layerConfigurationBorderColorKey) }
    set {
      _ = Self.layerConfigurationSwizzler
      setAssociatedObject(newValue, forKey: &layerConfigurationBorderColorKey)
      layer.borderColor = (newValue ?? tintColor).cgColor
    }
  }

  /// Set to negative to use `1 / traitCollection.displayScale`. Default is 0.
  /// We're supposed to use `nil` but IB does not support optional type.
  @IBInspectable public var layerConfigurationBorderWidth: CGFloat {
    get { return associatedValue(forKey: &layerConfigurationBorderWidthKey) ?? layer.borderWidth }
    set {
      _ = Self.layerConfigurationSwizzler
      setAssociatedValue(newValue, forKey: &layerConfigurationBorderWidthKey)
      if layerConfigurationBorderColor == nil {
        layer.borderColor = tintColor.cgColor
      }
      layer.borderWidth = newValue < 0 ? (1 / traitCollection.displayScale) : newValue
    }
  }

  /// - See: https://stackoverflow.com/a/73680511/11235826
  @IBInspectable public var layerShouldRasterizeWithDisplayScale: Bool {
    get { return associatedValue(forKey: &layerShouldRasterizeWithDisplayScaleKey, default: false) }
    set {
      _ = Self.layerConfigurationSwizzler
      setAssociatedValue(newValue, forKey: &layerShouldRasterizeWithDisplayScaleKey)
      layer.rasterizationScale = newValue ? traitCollection.displayScale : 1
      layer.shouldRasterize = newValue
    }
  }

  private static let layerConfigurationSwizzler: Void = {
    let klass = UIView.self
    class_exchangeInstanceMethodImplementations(klass, #selector(traitCollectionDidChange(_:)), #selector(_sklyr_traitCollectionDidChange(_:)))
    class_exchangeInstanceMethodImplementations(klass, #selector(tintColorDidChange), #selector(_sklyr_tintColorDidChange))
  }()

  @objc private func _sklyr_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    _sklyr_traitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *), let layerConfigurationBorderColor, traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      layer.borderColor = layerConfigurationBorderColor.cgColor
    }
    if layerConfigurationBorderWidth < 0 {
      layer.borderWidth = 1 / traitCollection.displayScale
    }
    if layerShouldRasterizeWithDisplayScale {
      layer.rasterizationScale = traitCollection.displayScale
    }
  }

  @objc private func _sklyr_tintColorDidChange() {
    _sklyr_tintColorDidChange()

    if layerConfigurationBorderColor == nil && window != nil {
      layer.borderColor = tintColor.cgColor
    }
  }
}

extension UIView.AutoresizingMask {
  
  public static var flexibleSize: UIView.AutoresizingMask {
    return [.flexibleWidth, .flexibleHeight]
  }
  
  public static var flexibleCenterX: UIView.AutoresizingMask {
    return [.flexibleLeftMargin, .flexibleRightMargin]
  }
  
  public static var flexibleCenterY: UIView.AutoresizingMask {
    return [.flexibleTopMargin, .flexibleBottomMargin]
  }
  
  public static var flexibleCenter: UIView.AutoresizingMask {
    return [.flexibleCenterX, .flexibleCenterY]
  }
}

extension NSObjectProtocol where Self: UIView {
  
  @inlinable
  public var withAutoLayout: Self {
    return with(\.translatesAutoresizingMaskIntoConstraints, false)
  }

  @available(*, deprecated, message: "Use `withAutoLayout.configure()` instead.")
  @discardableResult
  @inlinable
  public func withAutoLayout(configurationHandler: (Self) -> Void) -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    configurationHandler(self)
    return self
  }
}
#endif
