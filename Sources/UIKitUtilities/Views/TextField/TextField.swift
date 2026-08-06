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

  public enum InsetsReference {

    case none
    case layoutMargins(UIRectEdge)
  }

  public struct ViewLayoutAttributes {

    public var width: CGFloat?

    public var height: CGFloat?

    /// `height` is ignored if this property is `.fill`
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

// H:|-insets.left-[leftView]-leftLayoutAttributes.padding-[text]-rightLayoutAttributes.padding-[rightView]-insets.right-|
@IBDesignable
open class TextField: UITextField {

  /// The custom distance that the content is inset from edges (text or overlay views if they exist).
  open var insets: UIEdgeInsets = .zero

  open var insetsReference: InsetsReference = .none

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
    if let width = layoutAttributes.width {
      viewRect.size.width = width
    }
    if let height = layoutAttributes.height {
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
    var insets = insets
    switch insetsReference {
    case .none:
      break
    case .layoutMargins(let edges):
      let layoutMargins = layoutMargins
      if edges.contains(.top) {
        insets.top += layoutMargins.top
      }
      if edges.contains(.left) {
        insets.left += layoutMargins.left
      }
      if edges.contains(.bottom) {
        insets.bottom += layoutMargins.bottom
      }
      if edges.contains(.right) {
        insets.right += layoutMargins.right
      }
    }
    return insets
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

  @IBInspectable public var topInset: CGFloat {
    get { return insets.top }
    set { insets.top = newValue }
  }

  @IBInspectable public var leftInset: CGFloat {
    get { return insets.left }
    set { insets.left = newValue }
  }

  @IBInspectable public var bottomInset: CGFloat {
    get { return insets.bottom }
    set { insets.bottom = newValue }
  }

  @IBInspectable public var rightInset: CGFloat {
    get { return insets.right }
    set { insets.right = newValue }
  }

  @IBInspectable public var leftViewPadding: CGFloat {
    get { return leftViewLayoutAttributes.padding }
    set { leftViewLayoutAttributes.padding = newValue }
  }

  @IBInspectable public var rightViewPadding: CGFloat {
    get { return rightViewLayoutAttributes.padding }
    set { rightViewLayoutAttributes.padding = newValue }
  }
}

#endif
