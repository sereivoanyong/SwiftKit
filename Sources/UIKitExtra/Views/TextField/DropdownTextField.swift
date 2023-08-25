//
//  DropdownTextField.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

#if os(iOS)

import UIKit

@IBDesignable
open class DropdownTextField: TextField {

  public static var defaultDropdownImage: UIImage?

  private var defaultDropdownImage: UIImage? {
    if let image = Self.defaultDropdownImage {
      return image
    }
    if #available(iOS 13.0, *), let image = UIImage(systemName: "chevron.down") {
      return image
    }
    return nil
  }

  public let dropdownView: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = .lightGray
    if #available(iOS 13.0, *) {
      imageView.preferredSymbolConfiguration = .init(scale: .small)
    }
    return imageView
  }()

  // Space between dropdown and its sibling content (text or right view if exists)
  open var dropdownViewPadding: CGFloat = 5 {
    didSet {
      setNeedsLayout()
    }
  }

  @IBInspectable
  open var dropdownImage: UIImage! {
    get { dropdownView.image }
    set { dropdownView.image = newValue ?? defaultDropdownImage }
  }

  open override var isEditing: Bool {
    // Caret is still shown, but user cannot edit text
    false
  }

  // MARK: Initializer

  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    _ = Self.swizzlingHandler

    autocapitalizationType = .none
    autocorrectionType = .no // See: https://github.com/hackiftekhar/IQKeyboardManager/issues/1616#issuecomment-566500228
    spellCheckingType = .no
    if #available(iOS 11.0, *) {
      smartQuotesType = .no
      smartDashesType = .no
      smartInsertDeleteType = .no
    }

    // setBecomesFirstResponderOnClearButtonTap(true)

    dropdownView.image = defaultDropdownImage
    addSubview(dropdownView)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    dropdownView.frame = dropdownViewRect(forBounds: bounds)
  }

  override func adjustedTextRect(forTextRect textRect: CGRect, forEditing: Bool) -> CGRect {
    var adjustedTextRect = super.adjustedTextRect(forTextRect: textRect, forEditing: forEditing)
    adjustedTextRect.size.width -= dropdownViewSize.width + dropdownViewPadding
    return adjustedTextRect
  }

  open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    var clearButtonRect = super.clearButtonRect(forBounds: bounds)
    clearButtonRect.origin.x -= dropdownViewSize.width + dropdownViewPadding
    return clearButtonRect
  }

  open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    var rightViewRect = super.rightViewRect(forBounds: bounds)
    rightViewRect.origin.x -= dropdownViewSize.width + dropdownViewPadding
    return rightViewRect
  }

  open var dropdownViewSize: CGSize {
    if dropdownView.frame.size == .zero {
      dropdownView.sizeToFit()
    }
    return dropdownView.frame.size
  }

  open func dropdownViewRect(forBounds bounds: CGRect) -> CGRect {
    let size = dropdownView.systemLayoutSizeFitting(bounds.size)
    return CGRect(origin: CGPoint(x: bounds.width - insets.right - size.width, y: (bounds.height - size.height) / 2), size: size)
  }

  open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    // Disable cut, paste and delete actions
    switch action {
    case #selector(cut(_:)), #selector(paste(_:)), #selector(delete(_:)):
      return false
    default:
      return super.canPerformAction(action, withSender: sender)
    }
  }

  open override func closestPosition(to point: CGPoint) -> UITextPosition? {
    // Prevent users from moving cursor by always sending it to the end of document.
    // See: https://stackoverflow.com/a/48371073/11235826
    endOfDocument
  }

  static func wrapperView(inputView: UIView) -> UIView {
    let wrapperView = UIView()
    wrapperView.translatesAutoresizingMaskIntoConstraints = false

    inputView.translatesAutoresizingMaskIntoConstraints = false
    wrapperView.addSubview(inputView)

    let wrapperViewBottomAnchor: NSLayoutYAxisAnchor
    if #available(iOS 11.0, *) {
      wrapperViewBottomAnchor = wrapperView.safeAreaLayoutGuide.bottomAnchor
    } else {
      wrapperViewBottomAnchor = wrapperView.bottomAnchor
    }

    NSLayoutConstraint.activate([
      inputView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
      inputView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
      wrapperViewBottomAnchor.constraint(equalTo: inputView.bottomAnchor),
      wrapperView.trailingAnchor.constraint(equalTo: inputView.trailingAnchor),
    ])
    return wrapperView
  }

  // MARK: Clear

  open func clear() {

  }
}

extension DropdownTextField {

  private static let swizzlingHandler: Void = {
    let selector = Selector(("_clearButtonClicked:"))
    if instancesRespond(to: selector) {
      class_exchangeInstanceMethodImplementations(DropdownTextField.self, selector, #selector(_uikitswift_clearButtonClicked))
    }
  }()

  @objc private func _uikitswift_clearButtonClicked(_ sender: Any?) {
    let textBefore = text
    _uikitswift_clearButtonClicked(sender)
    if textBefore != text {
      clear()
      resignFirstResponder()
    }
  }
}

#endif
