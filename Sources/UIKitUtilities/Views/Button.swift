//
//  Button.swift
//
//  Created by Sereivoan Yong on 11/5/23.
//

import UIKit
import SwiftKit

@available(iOS 13.0, *)
@IBDesignable open class Button: UIButton {

  lazy private var backgroundView: BCBackgroundView = {
    let backgroundView = BCBackgroundView(frame: bounds, configuration: bcConfiguration.background)
    backgroundView.autoresizingMask = .flexibleSize
    insertSubview(backgroundView, at: 0)
    return backgroundView
  }()

  private var needsBCConfiguration: Bool {
    if #available(iOS 15.0, *), !overrideConfigurationWithBCConfiguration {
      return false
    }
    return true
  }

  open var overrideConfigurationWithBCConfiguration: Bool = true

  open var bcConfiguration: BCConfiguration = .init() {
    didSet {
      guard needsBCConfiguration else { return }

      if bcConfiguration.style != oldValue.style {
        reloadColorsForImageAndTitle()
        reloadColorForImageAndTitleForCurrentState()
        reloadBackgroundBackgroundColorForCurrentState()
      }
      if bcConfiguration.size != oldValue.size || bcConfiguration.cornerStyle != oldValue.cornerStyle {
        reloadBackgroundCornerRadius()
      }
      if bcConfiguration.background != oldValue.background {
        backgroundView.configuration = bcConfiguration.background
      }
      if bcConfiguration.contentInsets != oldValue.contentInsets {
        setNeedsLayout()
      }
    }
  }

  /// Default is `.plain`.
  open var configurationStyle: BCConfiguration.Style {
    get { return bcConfiguration.style }
    set { bcConfiguration.style = newValue }
  }
  @IBInspectable public var configurationStyleRaw: Int {
    get { return bcConfiguration.style.rawValue }
    set { bcConfiguration.style = BCConfiguration.Style(rawValue: newValue) ?? .plain }
  }

  /// Default is `.medium`.
  open var configurationSize: BCConfiguration.Size {
    get { return bcConfiguration.size }
    set { bcConfiguration.size = newValue }
  }
  @IBInspectable public var configurationSizeRaw: Int {
    get { return bcConfiguration.size.rawValue }
    set { bcConfiguration.size = BCConfiguration.Size(rawValue: newValue) ?? .medium }
  }

  /// Default is `.dynamic`.
  open var configurationCornerStyle: BCConfiguration.CornerStyle {
    get { return bcConfiguration.cornerStyle }
    set { bcConfiguration.cornerStyle = newValue }
  }
  @IBInspectable public var configurationCornerStyleRaw: Int {
    get { return bcConfiguration.cornerStyle.rawValue }
    set { bcConfiguration.cornerStyle = BCConfiguration.CornerStyle(rawValue: newValue) ?? .dynamic }
  }

  /// Default is `nil`.
  @IBInspectable open var configurationBaseForegroundColor: UIColor? {
    get { return bcConfiguration.baseForegroundColor }
    set { bcConfiguration.baseForegroundColor = newValue }
  }

  /// Default is `nil`.
  @IBInspectable open var configurationBaseBackgroundColor: UIColor? {
    get { return bcConfiguration.baseBackgroundColor }
    set { bcConfiguration.baseBackgroundColor = newValue }
  }

  /// Default is `leading`.
  open var configurationImagePlacement: NSDirectionalRectEdge {
    get { return bcConfiguration.imagePlacement }
    set { bcConfiguration.imagePlacement = newValue }
  }
  @IBInspectable public var configurationImagePlacementRaw: UInt { // top=1, leading=2 (default), bottom=4, trailing=8
    get { return bcConfiguration.imagePlacement.rawValue }
    set { bcConfiguration.imagePlacement = NSDirectionalRectEdge(rawValue: newValue) }
  }

  /// Default is 0.
  @IBInspectable open var configurationImagePadding: CGFloat {
    get { return bcConfiguration.imagePadding }
    set { bcConfiguration.imagePadding = newValue }
  }

  open var imageTintColorTransform: (UIColor) -> UIColor = { $0 }

  open override var frame: CGRect {
    didSet {
      reloadBackgroundCornerRadius()
    }
  }

  open override var isEnabled: Bool {
    didSet {
      reloadState()
    }
  }

  open override var isSelected: Bool {
    didSet {
      reloadState()
    }
  }

  open override var isHighlighted: Bool {
    didSet {
      reloadState()
    }
  }

  var currentState: State = .normal {
    didSet {
      reloadColorForImageAndTitleForCurrentState()
      reloadBackgroundBackgroundColorForCurrentState()
    }
  }

  var colorForImageAndTitleForState: [State.RawValue: UIColor] = [:]

  // MARK: Override Size

  /// If this value is set to non-nil, `contentEdgeInsets`, `titleEdgeInsets`, and `imageEdgeInsets` will be ignored.
  /// Must be set before `configure()`
  open var overrideSize: CGSize?

  open override var intrinsicContentSize: CGSize {
    return overrideSize ?? super.intrinsicContentSize
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    return overrideSize ?? super.sizeThatFits(size)
  }

  // MARK: Init

  public override init(frame: CGRect) {
    super.init(frame: frame)
    adjustsImageWhenHighlighted = false
    adjustsImageWhenDisabled = false
    check()
    reloadState()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  open override func awakeFromNib() {
    super.awakeFromNib()
    check()
    reloadState()
    configure()
  }

  private func check() {
    if buttonType != .custom {
      printIfDEBUG("`buttonType` must be `.custom`")
    }
    if adjustsImageWhenHighlighted {
      printIfDEBUG("`adjustsImageWhenHighlighted` should be `false`")
      adjustsImageWhenHighlighted = false
    }
    if adjustsImageWhenDisabled {
      printIfDEBUG("`adjustsImageWhenDisabled` should be `false`")
      adjustsImageWhenDisabled = false
    }
  }

  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    configure()
  }

  open func configure() {
    if #available(iOS 15.0, *), !overrideConfigurationWithBCConfiguration {
      configuration = Configuration(bcConfiguration)
      return
    }

    reloadColorsForImageAndTitle()
    reloadColorForImageAndTitleForCurrentState()
    reloadBackgroundBackgroundColorForCurrentState()
  }

  private func reloadState() {
    if isEnabled {
      if isHighlighted {
        if isSelected {
          currentState = [.highlighted, .selected]
        } else {
          currentState = [.highlighted]
        }
      } else {
        if isSelected {
          currentState = .selected
        } else {
          currentState = .normal
        }
      }
    } else {
      currentState = .disabled
    }
  }

  func colorForImageAndTitle(for state: State) -> UIColor {
    return colorForImageAndTitleForState[state.rawValue] ?? tintColor
  }

  func setColorForImageAndTitle(_ color: UIColor?, for state: State) {
    colorForImageAndTitleForState[state.rawValue] = color
  }

  private func reloadColorsForImageAndTitle() {
    guard needsBCConfiguration else { return }

    let titleColor: UIColor
    let highlightedTitleColor: UIColor
    var selectedTitleColor: UIColor?
    let highlightedSelectedTitleColor: UIColor
    switch configurationStyle {
    case .plain:
      titleColor = configurationBaseForegroundColor ?? tintColor
      highlightedTitleColor = UIColor { traitCollection in
        let resolvedColor = titleColor.resolvedColor(with: traitCollection)
        if traitCollection.userInterfaceStyle == .dark {
          let color = resolvedColor.withAlphaComponent(0.8)
          return color.opaque(on: .white) ?? color
        } else {
          return resolvedColor.withAlphaComponent(0.75)
        }
      }
      highlightedSelectedTitleColor = UIColor { traitCollection in
        let resolvedColor = titleColor.resolvedColor(with: traitCollection)
        if traitCollection.userInterfaceStyle == .dark {
          let color = resolvedColor.withAlphaComponent(0.9)
          return color.opaque(on: .white) ?? color
        } else {
          return resolvedColor.withAlphaComponent(0.75)
        }
      }
    case .gray:
      titleColor = configurationBaseForegroundColor ?? tintColor
      highlightedTitleColor = UIColor { traitCollection in
        let resolvedColor = titleColor.resolvedColor(with: traitCollection)
        if traitCollection.userInterfaceStyle == .dark {
          let color = resolvedColor.withAlphaComponent(0.9)
          return color.opaque(on: .white) ?? color
        } else {
          return resolvedColor.withAlphaComponent(0.75)
        }
      }
      highlightedSelectedTitleColor = UIColor { traitCollection in
        let resolvedColor = titleColor.resolvedColor(with: traitCollection)
        if traitCollection.userInterfaceStyle == .dark {
          let color = resolvedColor.withAlphaComponent(0.9)
          return color.opaque(on: .white) ?? color
        } else {
          return resolvedColor.withAlphaComponent(0.75)
        }
      }
    case .tinted:
      titleColor = configurationBaseForegroundColor ?? tintColor
      highlightedTitleColor = UIColor { traitCollection in
        let resolvedColor = titleColor.resolvedColor(with: traitCollection)
        if traitCollection.userInterfaceStyle == .dark {
          let color = resolvedColor.withAlphaComponent(0.9)
          return color.opaque(on: .white) ?? color
        } else {
          return resolvedColor.withAlphaComponent(0.75)
        }
      }
      selectedTitleColor = .white
      highlightedSelectedTitleColor = .white.withAlphaComponent(0.75)
    case .filled:
      titleColor = configurationBaseForegroundColor ?? .white
      highlightedTitleColor = UIColor { traitCollection in
        let resolvedColor = titleColor.resolvedColor(with: traitCollection)
        return resolvedColor.withAlphaComponent(0.75)
      }
      selectedTitleColor = .white
      highlightedSelectedTitleColor = .white.withAlphaComponent(0.75)
    }
    setColorForImageAndTitle(titleColor, for: .normal)
    setColorForImageAndTitle(highlightedTitleColor, for: .highlighted)
    setColorForImageAndTitle(selectedTitleColor, for: .selected)
    setColorForImageAndTitle(highlightedSelectedTitleColor, for: [.highlighted, .selected])
    setColorForImageAndTitle(.tertiaryLabel, for: .disabled)
  }

  private func reloadColorForImageAndTitleForCurrentState() {
    guard needsBCConfiguration else { return }

    let color = colorForImageAndTitle(for: currentState)
    imageView?.tintColor = imageTintColorTransform(color)
    setTitleColor(color, for: .normal)
  }

  /// Based on `frame`, `size` and `cornerStyle`. Currently all `cornerStyle`s are not fully supported.
  private func reloadBackgroundCornerRadius() {
    guard needsBCConfiguration else { return }

    let cornerRadius: CGFloat
    switch bcConfiguration.cornerStyle {
    case .fixed:
      return
    case .capsule:
      cornerRadius = frame.size.height / 2
    default:
      switch bcConfiguration.size {
      case .mini:   cornerRadius = 14
      case .small:  cornerRadius = 14
      case .medium: cornerRadius = 5.95
      case .large:  cornerRadius = 8.75
      }
    }
    backgroundView.configuration.cornerRadius = cornerRadius
  }

  /// Based on `currentState` and `style`.
  private func reloadBackgroundBackgroundColorForCurrentState() {
    guard needsBCConfiguration else { return }

    let backgroundColor: UIColor
    if !isEnabled {
      switch bcConfiguration.style {
      case .plain:
        backgroundColor = .clear
      case .gray:
        backgroundColor = .tertiarySystemFill
      case .tinted:
        backgroundColor = .tertiarySystemFill
      case .filled:
        backgroundColor = .tertiarySystemFill
      }
    } else if isSelected {
      if isHighlighted {
        switch bcConfiguration.style {
        case .plain:
          backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.18 : 0.12)
        case .gray:
          backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.18 : 0.12)
        case .tinted:
          if traitCollection.userInterfaceStyle == .dark {
            let color = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(0.8)
            backgroundColor = color.opaque(on: .white) ?? color
          } else {
            backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(0.75)
          }
        case .filled:
          if traitCollection.userInterfaceStyle == .dark {
            let color = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(0.8)
            backgroundColor = color.opaque(on: .white) ?? color
          } else {
            backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(0.75)
          }
        }
      } else {
        switch bcConfiguration.style {
        case .plain:
          backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.25 : 0.18)
        case .gray:
          backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.25 : 0.18)
        case .tinted:
          backgroundColor = configurationBaseBackgroundColor ?? tintColor
        case .filled:
          backgroundColor = configurationBaseBackgroundColor ?? tintColor
        }
      }
    } else if isHighlighted {
      switch bcConfiguration.style {
      case .plain:
        backgroundColor = configurationBaseBackgroundColor ?? .clear
      case .gray:
        // R:0.55 G:0.55 B:0.57 A:0.35
        backgroundColor = traitCollection.userInterfaceStyle == .dark ? (configurationBaseBackgroundColor ?? UIColor(red: 140/255.0, green: 140/255.0, blue: 147/255.0, alpha: 0.35)) : (configurationBaseBackgroundColor ?? .secondarySystemFill).withAlphaComponent(0.12)
      case .tinted:
        backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.18 : 0.12)
      case .filled:
        if traitCollection.userInterfaceStyle == .dark {
          let color = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(0.8)
          backgroundColor = color.opaque(on: .white) ?? color
        } else {
          backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(0.75)
        }
      }
    } else {
      switch bcConfiguration.style {
      case .plain:
        backgroundColor = configurationBaseBackgroundColor ?? .clear
      case .gray:
        backgroundColor = configurationBaseBackgroundColor ?? .secondarySystemFill
      case .tinted:
        backgroundColor = (configurationBaseBackgroundColor ?? tintColor).withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.25 : 0.18)
      case .filled:
        backgroundColor = (configurationBaseBackgroundColor ?? tintColor)
      }
    }

    backgroundView.configuration.backgroundColor = backgroundColor
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    guard needsBCConfiguration else { return }

    if subviews.first != backgroundView {
      sendSubviewToBack(backgroundView)
    }

    if overrideSize != nil {
      if bcConfiguration.cornerStyle == .capsule {
        backgroundView.configuration.cornerRadius = frame.size.height / 2
      }
      contentEdgeInsets = .zero
      titleEdgeInsets = .zero
      imageEdgeInsets = .zero
      return
    }

    var insets = bcConfiguration.contentInsets.resolved(with: effectiveUserInterfaceLayoutDirection)
    // insets.top += 4 - UIScreen.main.pointPerPixel
    // insets.bottom += 4 - UIScreen.main.pointPerPixel

    if let titleLabel, let imageView {
      let imageSize = imageView.frame.size
      let titleSize = titleLabel.frame.size
      if imageSize != .zero && titleSize != .zero {
        switch bcConfiguration.imagePlacement {
        case .top:
          let systemContentWidth = imageSize.width + titleSize.width
          let contentHeight = imageSize.height + bcConfiguration.imagePadding + titleSize.height

          let hInset = (systemContentWidth - max(imageSize.width, titleSize.width)) / 2
          insets.left -= hInset
          insets.right -= hInset
          insets.top += (contentHeight - max(imageSize.height, titleSize.height)) / 2
          insets.bottom += (contentHeight - max(imageSize.height, titleSize.height)) / 2
          imageEdgeInsets = UIEdgeInsets(top: -(contentHeight - imageSize.height), left: 0, bottom: 0, right: -titleSize.width)
          titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(contentHeight - titleSize.height), right: 0)

        case .bottom:
          let systemContentWidth = imageSize.width + titleSize.width
          let contentHeight = imageSize.height + bcConfiguration.imagePadding + titleSize.height

          let hInset = (systemContentWidth - max(imageSize.width, titleSize.width)) / 2
          insets.left -= hInset
          insets.right -= hInset
          insets.top += (contentHeight - max(imageSize.height, titleSize.height)) / 2
          insets.bottom += (contentHeight - max(imageSize.height, titleSize.height)) / 2
          titleEdgeInsets = UIEdgeInsets(top: -(contentHeight - titleSize.height), left: -imageSize.width, bottom: 0, right: 0)
          imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -(contentHeight - imageSize.height), right: -titleSize.width)

        case .trailing:
          let dx = bcConfiguration.imagePadding / 2
          insets.left += dx
          insets.right += dx
          contentEdgeInsets = insets
          titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + dx), bottom: 0, right: imageSize.width + dx)
          imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + dx, bottom: 0, right: -(titleSize.width + dx))

        default: // Leading
          let dx = bcConfiguration.imagePadding / 2
          insets.left += dx
          insets.right += dx
          imageEdgeInsets = UIEdgeInsets(top: 0, left: -dx, bottom: 0, right: dx)
          titleEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: -dx)
        }
      }
    }
    contentEdgeInsets = insets
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      reloadColorForImageAndTitleForCurrentState()
      reloadBackgroundBackgroundColorForCurrentState()
    }
  }

  // MARK: Context Menu

  private var contextMenuInteractionController: ContextMenuInteractionController? {
    willSet {
      if let contextMenuInteractionController {
        removeTarget(self, action: #selector(presentContextMenu(_:)), for: .touchDown)
        removeInteraction(contextMenuInteractionController.interaction)
      }
    }
    didSet {
      if let contextMenuInteractionController {
        addTarget(self, action: #selector(presentContextMenu(_:)), for: .touchDown)
        addInteraction(contextMenuInteractionController.interaction)
      }
    }
  }

  open var overrideMenuWithBCMenu: Bool = false

  open var bcMenu: UIMenu? {
    didSet {
      if let bcMenu {
        contextMenuInteractionController = ContextMenuInteractionController(menu: bcMenu)
      } else {
        contextMenuInteractionController = nil
      }
    }
  }

  open var menuIfAvailable: UIMenu? {
    get {
      if #available(iOS 14.0, *), !overrideMenuWithBCMenu {
        return menu
      } else {
        return bcMenu
      }
    }
    set {
      if #available(iOS 14.0, *), !overrideMenuWithBCMenu {
        if newValue != nil && !showsMenuAsPrimaryAction {
          showsMenuAsPrimaryAction = true
        }
        menu = newValue
      } else {
        bcMenu = newValue
      }
    }
  }

  @objc private func presentContextMenu(_ sender: UIButton) {
    guard let contextMenuInteractionController else { return }
    contextMenuInteractionController.isEnabled = true
    contextMenuInteractionController.interaction.presentMenu(at: .zero)
    contextMenuInteractionController.isEnabled = false
  }
}

@available(iOS 13.0, *)
final private class ContextMenuInteractionController: NSObject, UIContextMenuInteractionDelegate {

  var interaction: UIContextMenuInteraction!

  var menu: UIMenu?

  var isEnabled: Bool = false

  init(menu: UIMenu? = nil) {
    super.init()
    self.interaction = UIContextMenuInteraction(delegate: self)
    self.menu = menu
  }

  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    guard isEnabled else { return nil }
    return UIContextMenuConfiguration(actionProvider:  { [unowned self] _ in
      menu
    })
  }
}
