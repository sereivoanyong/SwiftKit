//
//  Button.swift
//
//  Created by Sereivoan Yong on 11/5/23.
//

import UIKit

@available(iOS 13.0, *)
@IBDesignable open class Button: UIButton {

  open var bcConfiguration: BCConfiguration!

  open var configurationStyle: BCConfiguration.Style = .plain
  @IBInspectable public var configurationStyleRaw: Int {
    get { return configurationStyle.rawValue }
    set { configurationStyle = BCConfiguration.Style(rawValue: newValue) ?? .plain }
  }

  open var configurationSize: BCConfiguration.Size = .medium
  @IBInspectable public var configurationSizeRaw: Int {
    get { return configurationSize.rawValue }
    set { configurationSize = BCConfiguration.Size(rawValue: newValue) ?? .medium }
  }

  open var configurationCornerStyle: BCConfiguration.CornerStyle = .dynamic
  @IBInspectable public var configurationCornerStyleRaw: Int {
    get { return configurationCornerStyle.rawValue }
    set { configurationCornerStyle = BCConfiguration.CornerStyle(rawValue: newValue) ?? .dynamic }
  }

  open var configurationImagePlacement: NSDirectionalRectEdge = .leading // 1, 2, 4, 8
  @IBInspectable public var configurationImagePlacementRaw: UInt {
    get { return configurationImagePlacement.rawValue }
    set { configurationImagePlacement = NSDirectionalRectEdge(rawValue: newValue) }
  }

  @IBInspectable open var configurationImagePadding: CGFloat = 0

  open var overrideConfigurationWithBCConfiguration: Bool = true

  private var frameObservationForCorner: NSKeyValueObservation?

  private var backgroundView: BCBackgroundView!

  private var highlights: Bool = false {
    didSet {
      backgroundView?.setNeedsDisplay()
    }
  }

  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    configure()
  }

  open override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }

  open func configure() {
    var bcConfiguration = BCConfiguration(style: configurationStyle)
    bcConfiguration.size = configurationSize
    bcConfiguration.cornerStyle = configurationCornerStyle
    bcConfiguration.imagePlacement = configurationImagePlacement
    bcConfiguration.imagePadding = configurationImagePadding

    if #available(iOS 15.0, *), !overrideConfigurationWithBCConfiguration {
      configuration = Configuration(bcConfiguration)
      return
    }
    self.bcConfiguration = bcConfiguration

    if bcConfiguration.style == .filled {
      setTitleColor(.white, for: .normal)
    }

    backgroundView = BCBackgroundView(configuration: bcConfiguration.background)
    backgroundView.configuration = bcConfiguration.background
    backgroundView.frame = bounds
    backgroundView.autoresizingMask = .flexibleSize
    insertSubview(backgroundView, at: 0)

    switch bcConfiguration.cornerStyle {
    case .fixed:
      backgroundView.configuration.cornerRadius = bcConfiguration.background.cornerRadius
    case .dynamic:
      backgroundView.configuration.cornerRadius = bcConfiguration.background.cornerRadius
    case .small:
      backgroundView.configuration.cornerRadius = bcConfiguration.background.cornerRadius
    case .medium:
      backgroundView.configuration.cornerRadius = bcConfiguration.background.cornerRadius
    case .large:
      backgroundView.configuration.cornerRadius = bcConfiguration.background.cornerRadius
    case .capsule:
      frameObservationForCorner = observe(\.frame, options: [.initial, .new]) { button, _ in
        button.backgroundView.configuration.cornerRadius = button.frame.height / 2
      }
    }

    backgroundView.configuration.backgroundColorTransformer = .init { [unowned self] color in
      switch bcConfiguration.style {
      case .plain:
        return .clear
      case .gray:
        if highlights {
          if traitCollection.userInterfaceStyle == .dark {
            return .systemGray.withAlphaComponent(0.35)
          } else {
            return .secondarySystemFill.withAlphaComponent(0.12)
          }
        }
        return .secondarySystemFill
      case .tinted:
        if highlights {
          return color.withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.18 : 0.12)
        }
        return color.withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.25 : 0.18)
      case .filled:
        if highlights {
          return color.withAlphaComponent(0.75)
        }
        return color
      }
    }

    // Create action events for all possible interactions with this control
    addTarget(self, action: #selector(didTouchDownInside(_:)), for: [.touchDown, .touchDownRepeat])
    addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
    addTarget(self, action: #selector(didDragOutside(_:)), for: [.touchDragExit, .touchCancel])
    addTarget(self, action: #selector(didDragInside(_:)), for: .touchDragEnter)
  }

  @objc private func didTouchDownInside(_ sender: Button) {
    highlights = true
  }

  @objc private func didTouchUpInside(_ sender: Button) {
    highlights = false
  }

  @objc private func didDragOutside(_ sender: Button) {
    highlights = false
  }

  @objc private func didDragInside(_ sender: Button) {
    highlights = true
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    guard let bcConfiguration else { return }

    if subviews.first != backgroundView {
      sendSubviewToBack(backgroundView)
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
