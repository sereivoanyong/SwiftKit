//
//  NumberTextField.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

#if os(iOS)

import UIKit

public typealias DecimalTextField = NumberTextField<Decimal> // Formatted
public typealias DoubleTextField = NumberTextField<Double> // Formatted
public typealias FloatTextField = NumberTextField<Float> // Formatted
public typealias IntTextField = NumberTextField<Int> // Lossless

open class NumberTextField<Value: _ObjectiveCBridgeable & Comparable & AdditiveArithmetic>: TextField, UITextFieldDelegate where Value._ObjectiveCType: NSNumber {

  // Not called when the `value` is changed programmatically.
  public static var valueDidChangeNotification: Notification.Name {
    return Notification.Name("NumberTextFieldValueDidChangeNotification")
  }

  open override var delegate: UITextFieldDelegate? {
    get { return super.delegate }
    set {
      assert(newValue is Self, "`textField(_:shouldChangeCharactersIn:replacementString:)`")
      super.delegate = newValue
    }
  }

  open var transformer: NumberTransformer<Value>!

  open var minimumValue: Value? {
    didSet {
      if let minimumValue = minimumValue, let value = value, value < minimumValue {
        self.value = minimumValue
      }
    }
  }

  open var maximumValue: Value? {
    didSet {
      if let maximumValue = maximumValue, let value = value, value > maximumValue {
        self.value = maximumValue
      }
    }
  }

  open var showsSignForOverrideSignumWhenNotZero: Bool = false {
    willSet {
      if case .formatted(let formatter) = transformer, formatter.positivePrefix.isEmpty {
        fatalError()
      }
    }
  }

  open var overrideSignum: Int? {
    didSet {
      if let value = value {
        setValue(signumedValue(value), sendValueChangedActions: true)
      }
    }
  }

  private var _value: Value?

  /// New value will be transformed to validated version before setting.
  open var value: Value? {
    get { return _value }
    set { setValue(newValue) }
  }

  /// New text will be transformed to validated version before setting. `value` is always set first.
  open override var text: String? {
    get { return super.text }
    set(newText) { setText(newText)}
  }

  // MARK: Init

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    keyboardType = Value.self is LosslessStringConvertible.Type ? .numberPad : .decimalPad
    delegate = self
  }

  // MARK: Transform

  /// Possibly formatted
  open func text(from value: Value) -> String? {
    assert(transformer != nil, "`transformer` must be set.")
    return transformer.string(from: value)
  }

  /// if `newText` is not nil, it should be unformatted and number-parseable or it will be discarded.
  func setText(_ newText: String?, textTransform: (String) -> String = { $0 }, sendValueChangedActions: Bool = false) {
    if let newValue = newText.flatMap(value(from:)), let newText = newValue == .zero ? newText : text(from: newValue) {
      let newValidatedValue = validatedValue(newValue)
      _value = newValidatedValue
      super.text = textTransform(validatedText(newText, newValidatedValue))
    } else {
      _value = nil
      super.text = nil
    }
    if sendValueChangedActions {
      sendActions(for: .valueChanged)
      NotificationCenter.default.post(name: Self.valueDidChangeNotification, object: self)
    }
  }

  open func value(from text: String) -> Value? {
    assert(transformer != nil, "`transformer` must be set.")
    var text = text
    let plusSign = sign(signum: 1)
    if text.hasPrefix(plusSign) {
      text.removeFirst(plusSign.count)
    }
    return transformer.number(from: text)
  }

  func setValue(_ newValue: Value?, sendValueChangedActions: Bool = false) {
    if let newValue = newValue, let newText = text(from: newValue) {
      let newValidatedValue = validatedValue(newValue)
      _value = newValidatedValue
      super.text = validatedText(newText, newValidatedValue)
    } else {
      _value = nil
      super.text = nil
    }
    if sendValueChangedActions {
      sendActions(for: .valueChanged)
      NotificationCenter.default.post(name: Self.valueDidChangeNotification, object: self)
    }
  }

  open func validatedText(_ text: String, _ value: Value) -> String {
    let text = signedTextIfNeeded(text, value)
    return text
  }

  private func signedTextIfNeeded(_ text: String, _  value: Value) -> String {
    guard showsSignForOverrideSignumWhenNotZero && value != .zero else {
      return text
    }
    let signPrefix: String
    switch transformer! {
    case .formatted(let formatter):
      signPrefix = value > .zero ? formatter.plusSign : formatter.minusSign
    case .custom:
      signPrefix = value > .zero ? "+" : "-"
    }
    if text.hasPrefix(signPrefix) {
      return text
    }
    return signPrefix + text
  }

  /// Returns `nil` if the value is already valid.
  open func validatedValue(_ value: Value) -> Value {
    var value = clampedValue(value)
    value = signumedValue(value)
    return value
  }

  private func clampedValue(_ value: Value) -> Value {
    switch (minimumValue, maximumValue) {
    case (.some(let minimumValue), .some(let maximumValue)):
      let validRange = minimumValue...maximumValue
      return validRange ~= value ? value : min(max(value, minimumValue), maximumValue)

    case (.some(let minimumValue), .none):
      return value < minimumValue ? minimumValue : value

    case (.none, .some(let maximumValue)):
      return value > maximumValue ? maximumValue : value

    case (.none, .none):
      return value
    }
  }

  private func signumedValue(_ value: Value) -> Value {
    if let overrideSignum = overrideSignum, overrideSignum != signum(of: value) {
      // https://github.com/apple/swift/blob/93a78b490cc3f3c1023786930a825530ad3588c6/stdlib/public/core/Integers.swift#L364
      let newValue = .zero - value
      assert(signum(of: newValue) == overrideSignum)
      return newValue
    }
    return value
  }

  private func signum(of value: Value) -> Int {
    // https://github.com/apple/swift/blob/93a78b490cc3f3c1023786930a825530ad3588c6/stdlib/public/core/Integers.swift#L1253
    return (value > .zero ? 1 : 0) - (value < .zero ? 1 : 0)
  }

  private func sign(signum: Int) -> String {
    switch transformer! {
    case .formatted(let formatter):
      return signum == -1 ? formatter.minusSign : formatter.plusSign
    case .custom:
      return signum == -1 ? "-" : "+"
    }
  }

  // MARK: UITextFieldDelegate

  @objc open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString: String) -> Bool {
    assert(textField === self)
    var newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: replacementString)

    var textTransform: (String) -> String = { $0 }
    if case .formatted(let formatter) = transformer {
      newText = newText.replacingOccurrences(of: formatter.groupingSeparator, with: "")

      if Value.self is Decimal.Type {
        let decimalSeparator = formatter.decimalSeparator!
        if formatter.maximumFractionDigits > 0,
           let decimalSeparatorRange = newText.range(of: decimalSeparator),
           newText[decimalSeparatorRange.upperBound...].count > formatter.maximumFractionDigits {
          return false
        }
        /// Check if user has just type the `decimalSeparator`
        if newText.hasSuffix(decimalSeparator) {
          /// `formatter` can't parse if the string has `decimalSeparator` as its suffix, so we remove it and append it later via `textTransform`
          textTransform = { $0 + decimalSeparator }
          newText.removeLast(decimalSeparator.count)
        }
      }
    }

    let isNewTextEmpty: Bool
    if newText.isEmpty {
      isNewTextEmpty = true
    } else {
      // Check if newText contains just the sign for overriden signum
      if showsSignForOverrideSignumWhenNotZero, let overrideSignum = overrideSignum, newText == sign(signum: overrideSignum) {
        isNewTextEmpty = true
      } else {
        isNewTextEmpty = false
      }
    }
    if isNewTextEmpty {
      setText(nil, sendValueChangedActions: true)
      return false
    }

    setText(newText, textTransform: textTransform, sendValueChangedActions: true)
    return false
  }
}

extension NumberTextField {

  public convenience init(formatter: NumberFormatter, value: Value? = nil, placeholder: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil) {
    self.init()
    self.font = font
    self.textAlignment = textAlignment
    if #available(iOS 13.0, *) {
      self.textColor = textColor ?? .label
    } else {
      self.textColor = textColor
    }
    self.placeholder = placeholder
    self.transformer = .formatted(formatter)
    self.value = value
  }

  public convenience init(value: Value? = nil, placeholder: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil) where Value: LosslessStringConvertible {
    self.init()
    self.font = font
    self.textAlignment = textAlignment
    if #available(iOS 13.0, *) {
      self.textColor = textColor ?? .label
    } else {
      self.textColor = textColor
    }
    self.placeholder = placeholder
    self.transformer = .default
    self.value = value
  }
}

#endif
