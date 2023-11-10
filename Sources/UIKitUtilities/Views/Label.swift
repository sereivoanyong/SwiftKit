//
//  Label.swift
//
//  Created by Sereivoan Yong on 3/2/21.
//

import UIKit

extension Label {

  /// `UIListContentConfiguration`
  public struct ContentConfiguration {

    /// Configures the color of the text. A nil value uses the view's tint color; use `.clear` for no color (transparent).
    public var color: UIColor? // The original implementation is not optional tho

    /// Optional color transformer that is used to resolve the color. A nil value means the `color` is used as-is.
    public var colorTransformer: BCConfigurationColorTransformer?

    public init(color: UIColor? = nil, colorTransformer: BCConfigurationColorTransformer? = nil) {
      self.color = color
      self.colorTransformer = colorTransformer
    }

    public func resolvedColor(for tintColor: UIColor) -> UIColor {
      let color = color ?? tintColor
      if let colorTransformer {
        return colorTransformer(color)
      }
      return color
    }
  }
}

@IBDesignable
open class Label: UILabel {

  // Setting text color or background color (via nib) to default will not call the setters.
  // We use them to store initial values (required when creating via nib) and restore when their respective configurations are nil-out.
  private var _textColor: UIColor?
  private var _backgroundColor: UIColor?

  /// The current content configuration of the label.
  open var contentConfiguration: ContentConfiguration? {
    didSet {
      if let contentConfiguration {
        super.textColor = contentConfiguration.resolvedColor(for: tintColor)
      } else {
        super.textColor = _textColor
      }
    }
  }

  /// The current background configuration of the cell.
  open var backgroundConfiguration: BCBackgroundConfiguration? {
    didSet {
      if let backgroundConfiguration {
        super.backgroundColor = backgroundConfiguration.resolvedBackgroundColor(for: tintColor)
      } else {
        super.backgroundColor = _backgroundColor
      }
    }
  }

  /// The amount of space between the text and its boundaries.
  open var insets: UIEdgeInsets = .zero {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  // MARK: Overriden

  open override var textColor: UIColor! {
    get {
      contentConfiguration?.color ?? super.textColor
    }
    set {
      _textColor = newValue
      if var contentConfiguration {
        contentConfiguration.color = newValue
        self.contentConfiguration = contentConfiguration
      } else {
        super.textColor = newValue
      }
    }
  }

  open override var backgroundColor: UIColor? {
    get {
      backgroundConfiguration?.backgroundColor ?? super.backgroundColor
    }
    set {
      _backgroundColor = newValue
      if var backgroundConfiguration {
        backgroundConfiguration.backgroundColor = newValue
        self.backgroundConfiguration = backgroundConfiguration
      } else {
        super.backgroundColor = newValue
      }
    }
  }

  open override func tintColorDidChange() {
    super.tintColorDidChange()

    if let contentConfiguration, contentConfiguration.color == nil {
      super.textColor = contentConfiguration.resolvedColor(for: tintColor)
    }
    if let backgroundConfiguration, backgroundConfiguration.backgroundColor == nil {
      super.backgroundColor = backgroundConfiguration.resolvedBackgroundColor(for: tintColor)
    }
  }

  open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let textRect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
    let invertedInsets = UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
    return textRect.inset(by: invertedInsets)
  }

  open override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: insets))
  }
}

extension Label {

  @IBInspectable
  public var isContentConfigured: Bool {
    get { return contentConfiguration != nil }
    set { contentConfiguration = newValue ? .init(color: _textColor) : nil }
  }

  @IBInspectable
  public var isBackgroundConfigured: Bool {
    get { return backgroundConfiguration != nil }
    set { backgroundConfiguration = newValue ? .init(backgroundColor: _backgroundColor) : nil }
  }

  @IBInspectable
  public var topInset: CGFloat {
    get { return insets.top }
    set { insets.top = newValue }
  }

  @IBInspectable
  public var leftInset: CGFloat {
    get { return insets.left }
    set { insets.left = newValue }
  }

  @IBInspectable
  public var bottomInset: CGFloat {
    get { return insets.bottom }
    set { insets.bottom = newValue }
  }

  @IBInspectable
  public var rightInset: CGFloat {
    get { return insets.right }
    set { insets.right = newValue }
  }
}
