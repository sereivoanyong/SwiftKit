//
//  UIView+Layer.swift
//
//  Created by Sereivoan Yong on 13/5/23.
//

#if canImport(UIKit)
import UIKit

private var layerBorderWidthKey: Void?
private var layerBorderColorKey: Void?
private var layerShouldRasterizeAtDisplayScaleKey: Void?
private var layerShadowColorKey: Void?

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

  /// Set to negative (-1 preferred) to use `1 / traitCollection.displayScale`. Default is 0.
  /// We're supposed to use `nil` but IB does not support optional type.
  @IBInspectable public var layerBorderWidth: CGFloat {
    get { return associatedValue(forKey: &layerBorderWidthKey) ?? layer.borderWidth }
    set {
      setAssociatedValue(newValue, forKey: &layerBorderWidthKey)
      layer.borderWidth = newValue < 0 ? (1 / traitCollection.displayScale) : newValue
      _ = Self._layerSwizzler
    }
  }

  /// Set to `nil` to use `tintColor`. Default is `nil`.
  @IBInspectable public var layerBorderColor: UIColor? {
    get { return associatedObject(forKey: &layerBorderColorKey) }
    set {
      isLayerBorderColorConfigured = true
      setAssociatedObject(newValue, forKey: &layerBorderColorKey)
      layer.borderColor = resolveColor(newValue, from: traitCollection).cgColor
      _ = Self._layerSwizzler
    }
  }

  /// Set to `nil` to use `tintColor`. Default is `nil`.
  @IBInspectable public var layerShadowColor: UIColor? {
    get { return associatedObject(forKey: &layerShadowColorKey) }
    set {
      isLayerShadowColorConfigured = true
      setAssociatedObject(newValue, forKey: &layerShadowColorKey)
      layer.shadowColor = resolveColor(newValue, from: traitCollection).cgColor
      _ = Self._layerSwizzler
    }
  }

  /// - See: https://stackoverflow.com/a/73680511/11235826
  @IBInspectable public var layerShouldRasterizeAtDisplayScale: Bool {
    get { return associatedValue(forKey: &layerShouldRasterizeAtDisplayScaleKey, default: false) }
    set {
      setAssociatedValue(newValue, forKey: &layerShouldRasterizeAtDisplayScaleKey)
      layer.rasterizationScale = newValue ? traitCollection.displayScale : 1
      layer.shouldRasterize = newValue
    }
  }
}

private var isLayerBorderColorConfiguredKey: Void?
private var isLayerShadowColorConfiguredKey: Void?

extension UIView {

  private var isLayerBorderColorConfigured: Bool {
    get { return associatedValue(forKey: &isLayerBorderColorConfiguredKey, default: false) }
    set { setAssociatedValue(newValue, forKey: &isLayerBorderColorConfiguredKey) }
  }

  private var isLayerShadowColorConfigured: Bool {
    get { return associatedValue(forKey: &isLayerShadowColorConfiguredKey, default: false) }
    set { setAssociatedValue(newValue, forKey: &isLayerShadowColorConfiguredKey) }
  }

  private static let _layerSwizzler: Void = {
    let klass = UIView.self
    class_exchangeInstanceMethodImplementations(klass, #selector(didMoveToWindow), #selector(_layer_didMoveToSuperview))
    class_exchangeInstanceMethodImplementations(klass, #selector(didMoveToWindow), #selector(_layer_didMoveToWindow))
    class_exchangeInstanceMethodImplementations(klass, #selector(tintColorDidChange), #selector(_layer_tintColorDidChange))
    class_exchangeInstanceMethodImplementations(klass, #selector(traitCollectionDidChange(_:)), #selector(_layer_traitCollectionDidChange(_:)))
  }()

  private func reloadTraitCollectionBasedLayerConfigurations(_ previousTraitCollection: UITraitCollection? = nil) {
    if layerBorderWidth < 0 {
      layer.borderWidth = 1 / traitCollection.displayScale
    }
    if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      if isLayerBorderColorConfigured {
        layer.borderColor = resolveColor(layerBorderColor, from: traitCollection).cgColor
      }
      if isLayerShadowColorConfigured {
        layer.shadowColor = resolveColor(layerShadowColor, from: traitCollection).cgColor
      }
    }
    if layerShouldRasterizeAtDisplayScale {
      layer.rasterizationScale = traitCollection.displayScale
    }
  }

  // MARK: Swizzling Methods

  @objc private func _layer_didMoveToSuperview() {
    _layer_didMoveToSuperview()

    reloadTraitCollectionBasedLayerConfigurations()
  }

  @objc private func _layer_didMoveToWindow() {
    _layer_didMoveToWindow()

    reloadTraitCollectionBasedLayerConfigurations()
  }

  @objc private func _layer_tintColorDidChange() {
    _layer_tintColorDidChange()

    if isLayerBorderColorConfigured && layerBorderColor == nil {
      layer.borderColor = resolveColor(layerBorderColor, from: traitCollection).cgColor
    }
    if isLayerShadowColorConfigured && layerShadowColor == nil {
      layer.shadowColor = resolveColor(layerShadowColor, from: traitCollection).cgColor
    }
  }

  @objc private func _layer_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    _layer_traitCollectionDidChange(previousTraitCollection)

    reloadTraitCollectionBasedLayerConfigurations(previousTraitCollection)
  }
}
#endif
