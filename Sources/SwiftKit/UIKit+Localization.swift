//
//  UIKit+Localization.swift
//
//  Created by Sereivoan Yong on 1/17/22.
//

import UIKit

private func messageForSetOnlyProperty(_ property: String = #function) -> Never {
  fatalError("The \(property) property is reserved for the interface builder.")
}

extension UILabel {

  @IBInspectable
  final public var textLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { text = newValue.localized }
  }
}

extension UIButton {

  @IBInspectable
  final public var titleLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { setTitle(newValue.localized, for: .normal) }
  }
}

extension UITextView {

  @IBInspectable
  final public var textLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { text = newValue.localized }
  }
}

extension UITextField {

  @IBInspectable
  final public var placeholderLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { placeholder = newValue.localized }
  }
}

extension UINavigationItem {

  @IBInspectable
  final public var titleLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { title = newValue.localized }
  }
}
