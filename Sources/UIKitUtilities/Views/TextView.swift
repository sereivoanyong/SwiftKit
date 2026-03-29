//
//  TextView.swift
//
//  Created by Sereivoan Yong on 5/2/21.
//

import UIKit
import SwiftKit

@IBDesignable
open class TextView: UITextView {

  private var placeholderTextViewBindings: [NSKeyValueObservation] = []

  private var placeholderTextViewIfLoaded: UITextView?
  lazy open private(set) var placeholderTextView: UITextView = {
    let textView = UITextView()
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

    placeholderTextViewIfLoaded = textView

    bind(\.font, to: textView)
    bind(\.textAlignment, to: textView)
    bind(\.textContainer.exclusionPaths, to: textView)
    bind(\.textContainer.lineFragmentPadding, to: textView)
    bind(\.textContainerInset, to: textView)
    bind(\.layoutManager.usesFontLeading, to: textView)

    if text.isEmpty {
      insertSubview(textView, at: 0)
    }
    NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Self.textDidChangeNotification, object: self)
    return textView
  }()

  open override var text: String! {
    didSet {
      textDidChange()
    }
  }

  @IBInspectable
  open var placeholder: String? {
    get { return placeholderTextViewIfLoaded?.text }
    set { placeholderTextView.text = newValue }
  }

  open var attributedPlaceholder: NSAttributedString? {
    get { return placeholderTextViewIfLoaded?.attributedText }
    set { placeholderTextView.attributedText = newValue }
  }

  @IBInspectable
  open var placeholderColor: UIColor? {
    get { return placeholderTextViewIfLoaded?.textColor }
    set { placeholderTextView.textColor = newValue }
  }

  @IBInspectable
  open var minimumNumberOfVisibleLines: Int = 1 {
    didSet {
      assert(maximumNumberOfVisibleLines == 0 || minimumNumberOfVisibleLines <= maximumNumberOfVisibleLines)
      if allowsSelfSizing {
        invalidateIntrinsicContentSize()
      }
    }
  }

  @IBInspectable
  open var maximumNumberOfVisibleLines: Int = 0 {
    didSet {
      assert(maximumNumberOfVisibleLines == 0 || minimumNumberOfVisibleLines <= maximumNumberOfVisibleLines)
      if allowsSelfSizing {
        invalidateIntrinsicContentSize()
      }
    }
  }

  @IBInspectable
  open var allowsSelfSizing: Bool = false {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  open var selfSizingUpdateHandler: (() -> Void)?

  open override var intrinsicContentSize: CGSize {
    var intrinsicContentSize = super.intrinsicContentSize
    if allowsSelfSizing, let font {
      var height: CGFloat = intrinsicContentSize.height
      if height == UIView.noIntrinsicMetric {
        let numberOfLines = max(text.split(separator: "\n", omittingEmptySubsequences: false).count, minimumNumberOfVisibleLines)
        height = font.lineHeight(numberOfLines: numberOfLines).ceiledToPixel(scale: traitCollection.displayScale) + textContainerInset.vertical
      } else {
        let minimumHeight = font.lineHeight(numberOfLines: max(minimumNumberOfVisibleLines, 1)).ceiledToPixel(scale: traitCollection.displayScale) + textContainerInset.vertical
        height = max(height, minimumHeight)
      }
      if maximumNumberOfVisibleLines > 0 {
        let maximumHeight = font.lineHeight(numberOfLines: maximumNumberOfVisibleLines).ceiledToPixel(scale: traitCollection.displayScale) + textContainerInset.vertical
        height = min(height, maximumHeight)
      }
      intrinsicContentSize.height = height
    }
    return intrinsicContentSize
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    placeholderTextViewIfLoaded?.frame = CGRect(origin: .zero, size: bounds.size)
  }

  @objc open func textDidChange(_ notification: Notification) {
    textDidChange()
  }

  private func textDidChange() {
    updatePlaceholderTextView()
    if allowsSelfSizing {
      invalidateIntrinsicContentSize()
      selfSizingUpdateHandler?()
    }
  }

  private func updatePlaceholderTextView() {
    if text.isEmpty {
      insertSubview(placeholderTextView, at: 0)
    } else {
      placeholderTextViewIfLoaded?.removeFromSuperview()
    }
  }

  private func bind<Value>(_ keyPath: ReferenceWritableKeyPath<UITextView, Value>, to target: UITextView) {
    let binding = (self as UITextView).observe(keyPath, options: [.initial, .new]) { [unowned target] source, _ in
      target[keyPath: keyPath] = source[keyPath: keyPath]
    }
    placeholderTextViewBindings.append(binding)
  }
}
