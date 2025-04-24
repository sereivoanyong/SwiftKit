//
//  GradientView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/24/25.
//

import UIKit

extension GradientConfiguration.Location {

  final public class Provider: Equatable {

    public let provider: (CGRect) -> CGFloat

    public init(_ provider: @escaping (CGRect) -> CGFloat) {
      self.provider = provider
    }

    public func callAsFunction(_ rect: CGRect) -> CGFloat {
      provider(rect)
    }

    public static func == (lhs: Provider, rhs: Provider) -> Bool {
      return lhs === rhs
    }
  }
}

extension GradientConfiguration {

  public enum Location: Equatable {

    case absolute(CGFloat)

    case custom(Provider)

    public static func custom(_ provider: @escaping (CGRect) -> CGFloat) -> Self {
      return .custom(.init(provider))
    }

    func resolved(with rect: CGRect) -> CGFloat {
      switch self {
      case .absolute(let fraction):
        return fraction
      case .custom(let provider):
        return provider(rect)
      }
    }
  }
}

public struct GradientConfiguration: Equatable {

  /// An array of `UIColor` objects defining the color of each gradient stop. Animatable.
  /// Default is `nil`.
  public var colors: [UIColor]?

  /// An optional array of `Location` objects defining the location of each gradient stop. Animatable.
  /// Default is `nil`.
  public var locations: [Location]?

  /// The start point of the gradient when drawn in the layer’s coordinate space. Animatable.
  /// Default is `CGPoint(x: 0.5, y: 0)`.
  public var startPoint: CGPoint

  /// The end point of the gradient when drawn in the layer’s coordinate space. Animatable.
  /// Default is `CGPoint(x: 0.5, y: 1)`.
  public var endPoint: CGPoint

  /// Style of gradient drawn by the layer.
  /// Default is `.axial`.
  public var type: CAGradientLayerType

  // These values are taken from `CAGradientLayer()`
  public init(
    colors: [UIColor]? = nil,
    locations: [Location]? = nil,
    startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
    endPoint: CGPoint = CGPoint(x: 0.5, y: 1),
    type: CAGradientLayerType = .axial
  ) {
    self.colors = colors
    self.locations = locations
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.type = type
  }
}

open class GradientView: UIView {

  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }

  public override var layer: CAGradientLayer {
    return super.layer as! CAGradientLayer
  }

  open override var bounds: CGRect {
    didSet {
      let bounds = bounds
      guard bounds != oldValue else { return }
      layer.locations = configuration.locations?.map { $0.resolved(with: bounds) as NSNumber }
    }
  }

  open var configuration: GradientConfiguration = .init() {
    didSet {
      guard configuration != oldValue else { return }
      configure(configuration)
    }
  }

  public init(frame: CGRect = .zero, configuration: GradientConfiguration) {
    self.configuration = configuration
    super.init(frame: frame)
    commonInitWithFrame()
  }

  public override init(frame: CGRect) {
    configuration = .init()
    super.init(frame: frame)
    commonInitWithFrame()
  }

  public required init?(coder: NSCoder) {
    configuration = .init()
    super.init(coder: coder)
    commonInit()
  }

  private func commonInitWithFrame() {
    isOpaque = false
    isUserInteractionEnabled = false
    commonInit()
  }

  private func commonInit() {
    configure(configuration)
  }

  open override func awakeFromNib() {
    super.awakeFromNib()
    assert(!isOpaque)
    assert(!isUserInteractionEnabled)
  }

  private func configure(_ configuration: GradientConfiguration) {
    layer.colors = configuration.colors?.map(\.cgColor)
    let bounds = bounds
    layer.locations = configuration.locations?.map { $0.resolved(with: bounds) as NSNumber }
    layer.startPoint = configuration.startPoint
    layer.endPoint = configuration.endPoint
    layer.type = configuration.type
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      layer.colors = configuration.colors?.map { $0.resolvedColor(with: traitCollection).cgColor }
    }
  }
}

