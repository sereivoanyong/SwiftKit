//
//  PasswordTextField.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

#if os(iOS)

import UIKit

open class PasswordTextField: TextField {

  private var isSecureTextEntryObservation: NSKeyValueObservation?

  public static var isSecureTextEntryOnImage: UIImage?
  public static var isSecureTextEntryOffImage: UIImage?

  lazy open private(set) var isSecureTextEntryToggleButton: UIButton = {
    let button = UIButton(type: .custom)
    button.tintColor = .lightGray
    if #available(iOS 13.0, *) {
      button.setPreferredSymbolConfiguration(.init(scale: .small), forImageIn: .normal)
    } 
    button.setImage(Self.isSecureTextEntryOnImage, for: .normal)
    button.setImage(Self.isSecureTextEntryOffImage, for: .selected)
    button.isSelected = isSecureTextEntry
    isSecureTextEntryObservation = observe(\.isSecureTextEntry) { textField, _ in
      button.isSelected = textField.isSecureTextEntry
    }
    button.addTarget(self, action: #selector(toggleIsSecureTextEntry(_:)), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  deinit {
    // This is required prior to iOS 11
    isSecureTextEntryObservation?.invalidate()
  }

  private func commonInit() {
    isSecureTextEntry = true
    if #available(iOS 11.0, *) {
      textContentType = .password
    }
    rightView = isSecureTextEntryToggleButton
    rightViewMode = .always
  }

  @objc private func toggleIsSecureTextEntry(_ sender: UIButton) {
    isSecureTextEntry.toggle()
  }
}

#endif
