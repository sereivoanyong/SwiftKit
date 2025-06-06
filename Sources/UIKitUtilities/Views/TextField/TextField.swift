//
//  TextField.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

#if os(iOS)

import UIKit

// TextField
// ├- DropdownTextField
// |  ├- DatePicker
// |  └- PickerTextField
// ├- NumberTextField
// |  └- StepperTextField
// └- PasswordTextField

extension TextField {

  /*
  final private class TextInputMode: UITextInputMode {

    private var _primaryLanguage: String?
    override var primaryLanguage: String? {
      get { _primaryLanguage }
      set { _primaryLanguage = newValue }
    }

    convenience init(primaryLanguage: String) {
      self.init()
      self.primaryLanguage = primaryLanguage
    }
  }

  private var _textInputMode: UITextInputMode? = TextInputMode(primaryLanguage: "en-US")
  override var textInputMode: UITextInputMode? {
    get { _textInputMode }
    set { _textInputMode = newValue }
  }

  private var _textInputContextIdentifier: String? = "en-US"
  override var textInputContextIdentifier: String? {
    get { _textInputContextIdentifier }
    set { _textInputContextIdentifier = newValue }
  }
   */

  public struct ViewLayoutAttributes {

    public var overrideWidth: CGFloat?

    public var overrideHeight: CGFloat?

    /// Take precedence over `overrideHeight` if value is `.fill`
    public var verticalAlignment: ContentVerticalAlignment?

    /// The space between the overlay view and the edge.
    public var padding: CGFloat = 5
  }
}

// System spacing changes based on `borderType`
// H:|-systemSpacing-[text]-systemSpacing-|

// Clear button has fixed left/right spacing
// H:|-systemSpacing-[text]-3-[clearButton]-5-|

// If overlay view exists, the spacing or inset is 0
// H:|-0-[leftView]-0-[text]-0-[rightView]-0-|

// H:|-insets.left-[leftView]-layoutAttributes.spacing-[text]-layoutAttributes.spacing-[rightView]-insets.right-|
@IBDesignable
open class TextField: UITextField {

  /// The custom distance that the content is inset from edges (text or overlay views if they exist).
  open var insets: NSDirectionalEdgeInsets = .zero

  open var leftViewLayoutAttributes: ViewLayoutAttributes = .init()

  open var rightViewLayoutAttributes: ViewLayoutAttributes = .init()

  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    return adjustedTextRect(forTextRect: super.textRect(forBounds: bounds), forEditing: false)
  }

  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return adjustedTextRect(forTextRect: super.editingRect(forBounds: bounds), forEditing: true)
  }

  // Easier for subclasses to override one for all
  func adjustedTextRect(forTextRect textRect: CGRect, forEditing: Bool) -> CGRect {
    var insets = resolvedInsets()
    if isVisible(for: leftViewMode) {
      insets.left += leftViewLayoutAttributes.padding
    }
    if isVisible(for: rightViewMode) {
      insets.right += rightViewLayoutAttributes.padding
    }
    return textRect.inset(by: insets)
  }

  open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    var clearButtonRect = super.clearButtonRect(forBounds: bounds)
    let insets = resolvedInsets()
    clearButtonRect.origin.x -= insets.right
    return clearButtonRect
  }

  open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    assert(isVisible(for: leftViewMode))
    var leftViewRect = super.leftViewRect(forBounds: bounds)
    let insets = resolvedInsets()
    leftViewRect.origin.x += insets.left
    apply(leftViewLayoutAttributes, to: &leftViewRect)
    return leftViewRect
  }

  open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    assert(isVisible(for: rightViewMode))
    var rightViewRect = super.rightViewRect(forBounds: bounds)
    let insets = resolvedInsets()
    rightViewRect.origin.x -= insets.right
    apply(rightViewLayoutAttributes, to: &rightViewRect)
    return rightViewRect
  }

  private func apply(_ layoutAttributes: ViewLayoutAttributes, to viewRect: inout CGRect) {
    if let width = layoutAttributes.overrideWidth {
      viewRect.size.width = width
    }
    if let height = layoutAttributes.overrideHeight {
      viewRect.size.height = height
    }
    if let verticalAlignment = layoutAttributes.verticalAlignment {
      switch verticalAlignment {
      case .center:
        viewRect.origin.y = (bounds.height - viewRect.height) / 2
      case .top:
        viewRect.origin.y = 0
      case .bottom:
        viewRect.origin.y = bounds.height - viewRect.height
      case .fill:
        viewRect.origin.y = 0
        viewRect.size.height = bounds.height
      @unknown default:
        break
      }
    }
  }

  public func resolvedInsets() -> UIEdgeInsets {
    let insets = insets
    switch effectiveUserInterfaceLayoutDirection {
    case .leftToRight:
      return UIEdgeInsets(top: insets.top, left: insets.leading, bottom: insets.bottom, right: insets.trailing)
    case .rightToLeft:
      return UIEdgeInsets(top: insets.top, left: insets.trailing, bottom: insets.bottom, right: insets.leading)
    @unknown default:
      return UIEdgeInsets(top: insets.top, left: insets.leading, bottom: insets.bottom, right: insets.trailing)
    }
  }

  public func setBecomesFirstResponderOnClearButtonTap(_ becomesFirstResponderOnClearButtonTap: Bool) {
    let selector = Selector(("setBecomesFirstResponderOnClearButtonTap:"))
    if responds(to: selector) {
      perform(selector, with: becomesFirstResponderOnClearButtonTap)
    }
  }

  open func isClearButtonVisible() -> Bool {
    return hasText && isVisible(for: clearButtonMode)
  }

  open func isVisible(for mode: ViewMode) -> Bool {
    switch mode {
    case .never:
      return false
    case .whileEditing:
      return isEditing
    case .unlessEditing:
      return !isEditing
    case .always:
      return true
    @unknown default:
      return false
    }
  }
}

extension TextField {

  @IBInspectable
  public var topInset: CGFloat {
    get { return insets.top }
    set { insets.top = newValue }
  }

  @IBInspectable
  public var leadingInset: CGFloat {
    get { return insets.leading }
    set { insets.leading = newValue }
  }

  @IBInspectable
  public var bottomInset: CGFloat {
    get { return insets.bottom }
    set { insets.bottom = newValue }
  }

  @IBInspectable
  public var trailingInset: CGFloat {
    get { return insets.trailing }
    set { insets.trailing = newValue }
  }

  @available(*, deprecated)
  @IBInspectable
  public var leftInset: CGFloat {
    get { return insets.leading }
    set { insets.leading = newValue }
  }

  @available(*, deprecated)
  @IBInspectable
  public var rightInset: CGFloat {
    get { return insets.trailing }
    set { insets.trailing = newValue }
  }

  @IBInspectable
  public var leftViewPadding: CGFloat {
    get { return leftViewLayoutAttributes.padding }
    set { leftViewLayoutAttributes.padding = newValue }
  }

  @IBInspectable
  public var rightViewPadding: CGFloat {
    get { return rightViewLayoutAttributes.padding }
    set { rightViewLayoutAttributes.padding = newValue }
  }
}

#endif
