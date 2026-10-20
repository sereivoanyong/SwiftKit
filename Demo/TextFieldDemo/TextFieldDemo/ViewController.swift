//
//  ViewController.swift
//  TextFieldDemo
//
//  Created by Sereivoan Yong on 10/20/26.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak private var textField: UITextField!

  var core: NumberTextFieldCore<Decimal>!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    textField.keyboardType = .decimalPad
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 3
    formatter.numberStyle = .currency
    formatter.generatesDecimalNumbers = true
    core = .init(formatter: formatter, minimumValue: -10, maximumValue: 100000, textField: textField)
  }
}

extension Optional where Wrapped: Collection {

  public var isNilOrEmpty: Bool {
    switch self {
    case .none:
      return true
    case .some(let collection):
      return collection.isEmpty
    }
  }

  /// Returns nil if the collection is nil or empty.
  public var nonEmpty: Wrapped? {
    switch self {
    case .none:
      return nil
    case .some(let collection):
      return collection.isEmpty ? nil : collection
    }
  }
}

extension NumberFormatter {

  @inlinable
  public convenience init(numberStyle: Style, locale: Locale? = nil) {
    self.init()
    self.numberStyle = numberStyle
    self.locale = locale
  }

  @inlinable
  public func string<T: _ObjectiveCBridgeable>(from number: T) -> String? where T._ObjectiveCType: NSNumber {
    return string(from: number._bridgeToObjectiveC())
  }

  @inlinable
  public func decimal(from string: String) -> Decimal? {
    assert(generatesDecimalNumbers)
    return number(from: string) as! NSDecimalNumber? as Decimal?
  }
}

open class NumberTextField<Value: _ObjectiveCBridgeable & Comparable & AdditiveArithmetic>: UITextField, UITextFieldDelegate where Value._ObjectiveCType: NSNumber {

  // Not called when the `value` is changed programmatically.
  public static var valueDidChangeNotification: Notification.Name {
    return Notification.Name("NumberTextFieldValueDidChangeNotification")
  }
}

@MainActor private var coreKey: Void?

@MainActor open class NumberTextFieldCore<Value: _ObjectiveCBridgeable & Comparable & AdditiveArithmetic & Sendable>: NSObject, UITextFieldDelegate where Value._ObjectiveCType: NSNumber {

  public unowned let textField: UITextField

  /// Configure through `updateFormatter(_:)`, not directly, so the text can be reformatted.
  public private(set) var formatter: NumberFormatter

  open var text: String? {
    get { return textField.text }
    set(newText) { setText(newText) }
  }

  open var value: Value? {
    get { return parse(text) }
    set { setValue(newValue) }
  }

  /// If the `value` falls outside the new bound, it is clamped and `.valueChanged` is sent.
  /// To change both bounds, use `setBounds(minimum:maximum:)`.
  open var minimumValue: Value? {
    didSet {
      guard !isBatchingBounds else { return }
      checkBounds()
      if let minimumValue, let value, value < minimumValue {
        setValue(minimumValue, notifyValueChanged: true)
      }
    }
  }

  /// If the `value` falls outside the new bound, it is clamped and `.valueChanged` is sent.
  /// To change both bounds, use `setBounds(minimum:maximum:)`.
  open var maximumValue: Value? {
    didSet {
      guard !isBatchingBounds else { return }
      checkBounds()
      if let maximumValue, let value, value > maximumValue {
        setValue(maximumValue, notifyValueChanged: true)
      }
    }
  }

  private var isBatchingBounds: Bool = false

  // MARK: Init

  /// `formatter` must use `.decimal` style. It is copied, so later changes to the original have no effect.
  public init(formatter: NumberFormatter, minimumValue: Value? = nil, maximumValue: Value? = nil, textField: UITextField) {
    precondition(minimumValue == nil || maximumValue == nil || minimumValue! <= maximumValue!)
    self.formatter = formatter
    self.minimumValue = minimumValue
    self.maximumValue = maximumValue
    self.textField = textField
    if Value.self == Decimal.self {
      assert(formatter.generatesDecimalNumbers)
    }
    super.init()

    textField.delegate = self
    // delegate is weak: tie the core's lifetime to the field (needed for UIAlertController fields)
    objc_setAssociatedObject(textField, &coreKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    setValue(parse(text))  // clears junk, clamps, normalizes; silent
  }

  // MARK: Configuration

  /// Reformats the text with the new settings. Sends `.valueChanged` if the value changes (e.g. fewer fraction digits).
  open func updateFormatter(_ configure: (inout NumberFormatter) -> Void) {
    let oldValue = value  // parsed with the old settings
    configure(&formatter)
    setValue(oldValue)
    if value != clamped(oldValue) {
      sendValueChanged()
    }
  }

  open func setBounds(minimum: Value?, maximum: Value?) {
    precondition(minimum == nil || maximum == nil || minimum! <= maximum!)
    isBatchingBounds = true
    minimumValue = minimum
    maximumValue = maximum
    isBatchingBounds = false
    setValue(value, notifyValueChanged: true)  // clamps once; notifies only if the value changed
  }

  private func checkBounds() {
    precondition(minimumValue == nil || maximumValue == nil || minimumValue! <= maximumValue!, "minimumValue > maximumValue; use setBounds(minimum:maximum:)")
  }

  // MARK: Parse / format

  /// A trailing decimal separator ("1.") is ignored, so a strict formatter doesn't report nil mid-typing.
  open func parse(_ text: String?) -> Value? {
    guard let text else { return nil }
    var plain = ungrouped(text)
    if formatter.maximumFractionDigits > 0 && plain.hasSuffix(formatter.decimalSeparator) {
      plain.removeLast(formatter.decimalSeparator.count)
    }
    if !plain.isEmpty, let number = formatter.number(from: plain) as? Value._ObjectiveCType {
      var result: Value?
      if Value._conditionallyBridgeFromObjectiveC(number, result: &result) {
        return result
      }
    }
    return nil
  }

  /// Grouped and padded by the formatter.
  open func format(_ value: Value?) -> String? {
    guard let value else { return nil }
    return formatter.string(from: value._bridgeToObjectiveC())
  }

  func setText(_ newText: String?, notifyValueChanged: Bool = false) {
    setValue(parse(newText), notifyValueChanged: notifyValueChanged)
  }

  func setValue(_ newValue: Value?, notifyValueChanged: Bool = false) {
    let oldValue = value
    let newText = format(clamped(newValue))
    assert(newText == nil || grouped(ungrouped(newText!)) == newText!, "grouped(_:) disagrees with the formatter")
    if textField.text.nonEmpty != newText.nonEmpty {
      textField.text = newText // skip when equal: assigning moves the caret to the end
    }
    if notifyValueChanged && value != oldValue {
      sendValueChanged()
    }
  }

  func clamped(_ value: Value?) -> Value? {
    guard var value else { return nil }
    if let minimumValue, value < minimumValue {
      value = minimumValue
    }
    if let maximumValue, value > maximumValue {
      value = maximumValue
    }
    return value
  }

  func sendValueChanged() {
    textField.sendActions(for: .valueChanged)
    NotificationCenter.default.post(name: NumberTextField<Value>.valueDidChangeNotification, object: textField)
  }

  // MARK: UITextFieldDelegate

  open func textField(_ textField: UITextField, shouldChangeCharactersIn nsRange: NSRange, replacementString: String) -> Bool {
    let text = textField.text ?? ""
    guard var range = Range(nsRange, in: text) else { return false }

    if replacementString.isEmpty && !range.isEmpty {
      let textToReplace = String(text[range])
      if textToReplace != formatter.groupingSeparator && ungrouped(textToReplace).isEmpty && range.lowerBound > text.startIndex {
        range = text.index(before: range.lowerBound)..<range.upperBound
      }
    }

    let replacement = replacementString.replacingOccurrences(of: "-", with: formatter.minusSign)
    let rawText = text.replacingCharacters(in: range, with: replacement)
    let rawCaret = text.distance(from: text.startIndex, to: range.lowerBound) + replacement.count

    let plainRaw = ungrouped(rawText)
    let plain = normalized(plainRaw)
    let removedCount = plainRaw.count - plain.count

    guard let accepted = acceptedText(for: plain) else { return false }
    let resultText = grouped(accepted)
    guard resultText != text else { return false }

    let oldValue = value
    textField.text = resultText

    let significant = accepted == plain ? max(0, ungrouped(String(rawText.prefix(rawCaret))).count - removedCount) : accepted.count
    let offset = displayOffset(forSignificant: significant, in: resultText)
    if let position = textField.position(from: textField.beginningOfDocument, offset: offset) {
      textField.selectedTextRange = textField.textRange(from: position, to: position)
    }
    if value != oldValue {
      sendValueChanged()
    }
    return false
  }

  open func textFieldShouldClear(_ textField: UITextField) -> Bool {
    setValue(nil, notifyValueChanged: true)
    return false
  }

  open func textFieldDidEndEditing(_ textField: UITextField) {
    // clamps to minimumValue, pads fraction digits, drops dangling "-" / "."
    setValue(value, notifyValueChanged: true)
  }

  // MARK: Typing validation (all on text without grouping separators)

  /// The text to apply for `newText`, or nil to reject the edit.
  private func acceptedText(for newText: String) -> String? {
    if newText.isEmpty { return newText }

    if let minimumValue, minimumValue >= .zero && newText.contains(formatter.minusSign) {
      return nil
    }

    if formatter.maximumFractionDigits > 0 {
      let parts = newText.components(separatedBy: formatter.decimalSeparator)
      if parts.count > 2 || (parts.count == 2 && parts[1].count > formatter.maximumFractionDigits) {
        return nil
      }
    } else if newText.contains(formatter.decimalSeparator) {
      return nil // integer-only: the separator can't be typed
    }

    if let newValue = parse(newText) {
      guard parse(format(newValue)) == newValue && isSignAllowed(newValue) else { return nil }
      if let bound = typingBound(for: newValue), let boundText = format(bound) {
        return ungrouped(boundText)
      }
      return newText
    }

    guard let probe = parse(newText + "1"), parse(format(probe)) == probe && isSignAllowed(probe) else { return nil }
    return newText
  }

  /// The text can still lead to an in-range value only if its sign allows it.
  private func isSignAllowed(_ value: Value) -> Bool {
    if let minimumValue, minimumValue >= .zero && value < .zero {
      return false
    }
    if let maximumValue, maximumValue < .zero && value > .zero {
      return false
    }
    return true
  }

  /// Returns the bound to clamp to when more typing can only push the value further out of range.
  private func typingBound(for value: Value) -> Value? {
    let zero = Value.zero
    if let maximumValue, value > maximumValue && value >= zero && maximumValue >= zero {
      return maximumValue
    }
    if let minimumValue, value < minimumValue && value <= zero && minimumValue <= zero {
      return minimumValue
    }
    return nil
  }

  // MARK: Text helpers

  /// ".11" -> "0.11", "-.5" -> "-0.5", "07" -> "7", "-007" -> "-7", "00" -> "0".
  /// "0", "0.5" and "-0." are untouched.
  private func normalized(_ text: String) -> String {
    var body = text
    var prefix: String?
    if let negativePrefix = formatter.negativePrefix, text.hasPrefix(negativePrefix) {
      prefix = negativePrefix
      body = String(body.dropFirst(negativePrefix.count))
    } else if let positivePrefix = formatter.positivePrefix, text.hasPrefix(positivePrefix) {
      prefix = positivePrefix
      body = String(body.dropFirst(positivePrefix.count))
    }

    if formatter.maximumFractionDigits > 0 && body.hasPrefix(formatter.decimalSeparator) {
      body = "0" + body
    }

    var digits = Substring(body)
    while let first = digits.first, first.wholeNumberValue == 0, let second = digits.dropFirst().first, second.isWholeNumber {
      digits = digits.dropFirst()
    }
    return (prefix.map { $0 + digits }) ?? String(digits)
  }

  private func ungrouped(_ text: String) -> String {
    guard formatter.usesGroupingSeparator && formatter.groupingSize > 0 else { return text }
    return text.replacingOccurrences(of: formatter.groupingSeparator, with: "")
  }

  /// Groups the integer part only: "-1234567.891" -> "-1,234,567.891". Handles in-progress text like "1234." that the formatter can't produce from a value.
  private func grouped(_ text: String) -> String {
    guard formatter.usesGroupingSeparator && formatter.groupingSize > 0 else { return text }
    let sign = text.hasPrefix(formatter.minusSign) ? formatter.minusSign! : ""
    let body = text.dropFirst(sign.count)

    var integerPart = body
    var rest: Substring = ""
    if formatter.maximumFractionDigits > 0, let r = body.range(of: formatter.decimalSeparator) {
      integerPart = body[..<r.lowerBound]
      rest = body[r.lowerBound...]
    }

    let primary = formatter.groupingSize
    let secondary = formatter.secondaryGroupingSize > 0 ? formatter.secondaryGroupingSize : primary

    var out: [Character] = []
    var size = primary, run = 0
    for ch in integerPart.reversed() {
      if run == size {
        out.append(contentsOf: formatter.groupingSeparator.reversed())
        run = 0
        size = secondary
      }
      out.append(ch)
      run += 1
    }
    return sign + String(out.reversed()) + rest
  }

  /// UTF-16 caret offset in `displayed` after `n` non-separator characters.
  private func displayOffset(forSignificant n: Int, in displayed: String) -> Int {
    let hasGrouping = formatter.usesGroupingSeparator && formatter.groupingSize > 0
    var count = 0
    var index = displayed.startIndex
    while index < displayed.endIndex, count < n {
      if hasGrouping && displayed[index...].hasPrefix(formatter.groupingSeparator) {
        index = displayed.index(index, offsetBy: formatter.groupingSeparator.count)
      } else {
        index = displayed.index(after: index)
        count += 1
      }
    }
    return displayed.utf16.distance(from: displayed.startIndex, to: index)
  }
}
