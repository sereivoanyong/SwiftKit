//
//  UIView+Layer.swift
//
//  Created by Sereivoan Yong on 13/5/23.
//

import UIKit

private var layerBorderWidthKey: Void?
private var layerBorderColorKey: Void?
private var layerShouldRasterizeAtDisplayScaleKey: Void?
private var layerShadowColorKey: Void?

extension UIView {

  /// Default is 0.
  @IBInspectable
  public var layerCornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set { layer.cornerRadius = newValue }
  }

  @available(iOS 13.0, *)
  @IBInspectable
  public var layerCornerCurve: CALayerCornerCurve {
    get { return layer.cornerCurve }
    set { layer.cornerCurve = newValue }
  }

  /// Default is `false`.
  @available(*, deprecated, message: "Use `layerCornerCurve` instead.")
  @IBInspectable
  public var layerContinuousCorners: Bool {
    get { return layer.continuousCorners }
    set { layer.continuousCorners = newValue }
  }

  /// Set to negative (-1 preferred) to use `traitCollection.displayPointPerPixel`. Default is 0.
  /// We're supposed to use `nil` but IB does not support optional type.
  @IBInspectable
  public var layerBorderWidth: CGFloat {
    get { return associatedValue(forKey: &layerBorderWidthKey, with: self) ?? layer.borderWidth }
    set {
      setAssociatedValue(newValue, forKey: &layerBorderWidthKey, with: self)
      layer.borderWidth = newValue < 0 ? traitCollection.displayPointPerPixel : newValue
      _ = Self._layerSwizzler
    }
  }

  /// Set to `nil` to use `tintColor`. Default is `nil`.
  @IBInspectable
  public var layerBorderColor: UIColor? {
    get { return associatedObject(forKey: &layerBorderColorKey, with: self) }
    set {
      isLayerBorderColorConfigured = true
      setAssociatedObject(newValue, forKey: &layerBorderColorKey, with: self)
      layer.borderColor = resolveColor(newValue, from: traitCollection).cgColor
      _ = Self._layerSwizzler
    }
  }

  /// Set to `nil` to use `tintColor`. Default is `nil`.
  @IBInspectable
  public var layerShadowColor: UIColor? {
    get { return associatedObject(forKey: &layerShadowColorKey, with: self) }
    set {
      isLayerShadowColorConfigured = true
      setAssociatedObject(newValue, forKey: &layerShadowColorKey, with: self)
      layer.shadowColor = resolveColor(newValue, from: traitCollection).cgColor
      _ = Self._layerSwizzler
    }
  }

  /// - See: https://stackoverflow.com/a/73680511/11235826
  @IBInspectable
  public var layerShouldRasterizeAtDisplayScale: Bool {
    get { return associatedValue(forKey: &layerShouldRasterizeAtDisplayScaleKey, with: self) ?? false }
    set {
      setAssociatedValue(newValue, forKey: &layerShouldRasterizeAtDisplayScaleKey, with: self)
      layer.rasterizationScale = newValue ? traitCollection.displayScale : 1
      layer.shouldRasterize = newValue
    }
  }
}

private var isLayerBorderColorConfiguredKey: Void?
private var isLayerShadowColorConfiguredKey: Void?

extension UIView {

  private var isLayerBorderColorConfigured: Bool {
    get { return associatedValue(forKey: &isLayerBorderColorConfiguredKey, with: self) ?? false }
    set { setAssociatedValue(newValue, forKey: &isLayerBorderColorConfiguredKey, with: self) }
  }

  private var isLayerShadowColorConfigured: Bool {
    get { return associatedValue(forKey: &isLayerShadowColorConfiguredKey, with: self) ?? false }
    set { setAssociatedValue(newValue, forKey: &isLayerShadowColorConfiguredKey, with: self) }
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
      layer.borderWidth = traitCollection.displayPointPerPixel
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
