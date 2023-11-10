//
//  TextView.swift
//
//  Created by Sereivoan Yong on 5/2/21.
//

import UIKit
import SwiftKit

@IBDesignable
open class TextView: UITextView {

  private var cachedFont: UIFont!
  open override var font: UIFont! {
    get {
      if let font = super.font {
        return font
      }
      if cachedFont == nil {
        let textBefore = text
        text = " "
        let font = super.font
        text = textBefore
        cachedFont = font
      }
      return cachedFont
    }
    set { super.font = newValue }
  }

  private var placeholderTextViewBindings: [NSKeyValueObservation] = []

  private var _placeholderTextView: UITextView?
  lazy open private(set) var placeholderTextView: UITextView = {
    let textView = UITextView(frame: bounds)
    textView.autoresizingMask = .flexibleSize
    textView.backgroundColor = .clear
    if #available(iOS 13.0, *) {
      textView.textColor = .placeholderText
    } else {
      // See: https://stackoverflow.com/a/43346157/11235826
      textView.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
    textView.isUserInteractionEnabled = false
    textView.isAccessibilityElement = false
    textView.showsHorizontalScrollIndicator = false
    textView.showsVerticalScrollIndicator = false

    bind(\.font, to: textView).store(in: &placeholderTextViewBindings)
    bind(\.textAlignment, to: textView).store(in: &placeholderTextViewBindings)
    bind(\.textContainer.layoutManager!.usesFontLeading, to: textView).store(in: &placeholderTextViewBindings)
    bind(\.textContainer.exclusionPaths, to: textView).store(in: &placeholderTextViewBindings)
    bind(\.textContainer.lineFragmentPadding, to: textView).store(in: &placeholderTextViewBindings)
    bind(\.textContainerInset, to: textView).store(in: &placeholderTextViewBindings)

    NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceholderTextView), name: UITextView.textDidChangeNotification, object: self)

    if text.isNilOrEmpty {
      insertSubview(textView, at: 0)
    }
    _placeholderTextView = textView
    return textView
  }()

  open override var text: String! {
    didSet {
      updatePlaceholderTextView()
    }
  }

  @IBInspectable
  open var placeholder: String? {
    get { return placeholderTextView.text }
    set { placeholderTextView.text = newValue }
  }

  open var attributedPlaceholder: NSAttributedString? {
    get { return placeholderTextView.attributedText }
    set { placeholderTextView.attributedText = newValue }
  }

  @IBInspectable
  open var placeholderColor: UIColor? {
    get { return placeholderTextView.textColor }
    set { placeholderTextView.textColor = newValue }
  }

  @IBInspectable
  open var minimumNumberOfLinesToDisplay: Int = 0 {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  open override var intrinsicContentSize: CGSize {
    var intrinsicContentSize = super.intrinsicContentSize
    if minimumNumberOfLinesToDisplay > 0 {
      let minimumHeight = textContainerInset.top + textContainerInset.bottom + font!.lineHeight * CGFloat(minimumNumberOfLinesToDisplay)
      intrinsicContentSize.height = max(minimumHeight, intrinsicContentSize.height)
    }
    return intrinsicContentSize
  }

  @objc private func updatePlaceholderTextView() {
    if text.isEmpty {
      insertSubview(placeholderTextView, at: 0)
    } else {
      placeholderTextView.removeFromSuperview()
    }
  }

//  func bind<Target, Value>(_ keyPath: KeyPath<TextView, Value>, to target: Target, at targetKeyPath: ReferenceWritableKeyPath<Target, Value>) -> NSKeyValueObservation {
//    observe(keyPath, options: [.initial, .new]) { source, _ in
//      target[keyPath: targetKeyPath] = source[keyPath: keyPath]
//    }
//  }

  func bind<Value>(_ keyPath: ReferenceWritableKeyPath<UITextView, Value>, to target: UITextView) -> NSKeyValueObservation {
    (self as UITextView).observe(keyPath, options: [.initial, .new]) { source, _ in
      target[keyPath: keyPath] = source[keyPath: keyPath]
    }
  }
}

extension NSKeyValueObservation {

  final func store<C>(in collection: inout C) where C: RangeReplaceableCollection, C.Element == NSKeyValueObservation {
    collection.append(self)
  }
}
