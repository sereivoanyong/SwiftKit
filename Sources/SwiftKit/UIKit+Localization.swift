//
//  UIKit+Localization.swift
//
//  Created by Sereivoan Yong on 1/17/22.
//

import UIKit

private func messageForSetOnlyProperty(_ property: String = #function) -> Never {
  fatalError("The \(property) property is reserved for the interface builder.")
}

private let lowercaseFlag = "[l]"
private let uppercaseFlag = "[u]"

private func localized(_ key: String) -> String {
  var key = key
  var transforms: [(String) -> String] = []
  if key.hasPrefix(lowercaseFlag) {
    key.removeFirst(lowercaseFlag.count)
    transforms.append({ $0.lowercased() })
  }
  if key.hasPrefix(uppercaseFlag) {
    key.removeFirst(uppercaseFlag.count)
    transforms.append({ $0.uppercased() })
  }
  var localized = key.localized
  for transform in transforms {
    localized = transform(localized)
  }
  return localized
}

extension UILabel {

  @IBInspectable
  public var textLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { text = localized(newValue) }
  }
}

extension UIButton {

  @IBInspectable
  public var titleLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { setTitle(localized(newValue), for: .normal) }
  }
}

extension UITextView {

  @IBInspectable
  public var textLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { text = localized(newValue) }
  }
}

extension UITextField {

  @IBInspectable
  public var placeholderLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { placeholder = localized(newValue) }
  }
}

extension UINavigationItem {

  @IBInspectable
  public var titleLocalization: String! {
    get { messageForSetOnlyProperty() }
    set { title = localized(newValue) }
  }
}
