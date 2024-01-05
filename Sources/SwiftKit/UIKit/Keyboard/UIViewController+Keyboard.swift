//
//  UIViewController+Keyboard.swift
//
//  Created by Sereivoan Yong on 1/5/24.
//

import UIKit

extension UIViewController {

  private static var viewKeyboardLayoutGuideHeightConstraintKey: Void?
  private var viewKeyboardLayoutGuideHeightConstraint: NSLayoutConstraint! {
    get { return associatedObject(forKey: &Self.viewKeyboardLayoutGuideHeightConstraintKey, with: self) }
    set { setAssociatedObject(newValue, forKey: &Self.viewKeyboardLayoutGuideHeightConstraintKey, with: self) }
  }

  private static var keyboardWillChangeFrameNotificationKey: Void?
  public private(set) var keyboardWillChangeFrameNotification: KeyboardNotification? {
    get { return associatedValue(forKey: &Self.keyboardWillChangeFrameNotificationKey, with: self) }
    set {
      setAssociatedValue(newValue, forKey: &Self.keyboardWillChangeFrameNotificationKey, with: self)
      updateViewKeyboardLayoutGuideConstraints()
      if let newValue {
        newValue.animate {
          self.view.layoutIfNeeded()
        }
      }
    }
  }

  private static var viewKeyboardLayoutGuideIfLoadedKey: Void?
  public private(set) var viewKeyboardLayoutGuideIfLoaded: KeyboardLayoutGuide? {
    get { return associatedObject(forKey: &Self.viewKeyboardLayoutGuideIfLoadedKey, with: self) }
    set { setAssociatedObject(newValue, forKey: &Self.viewKeyboardLayoutGuideIfLoadedKey, with: self) }
  }

  /// Accessing this property will also call `loadViewIfNeeded()`
  public var viewKeyboardLayoutGuide: KeyboardLayoutGuide {
    if let viewKeyboardLayoutGuideIfLoaded {
      return viewKeyboardLayoutGuideIfLoaded
    }

    loadViewIfNeeded()
    let layoutGuide = KeyboardLayoutGuide()
    viewKeyboardLayoutGuideIfLoaded = layoutGuide
    view.addLayoutGuide(layoutGuide)

    viewKeyboardLayoutGuideHeightConstraint = layoutGuide.heightAnchor.constraint(equalToConstant: 0)
    NSLayoutConstraint.activate([
      viewKeyboardLayoutGuideHeightConstraint,
      layoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
    ])
    updateViewKeyboardLayoutGuideConstraints()
    return layoutGuide
  }

  /// Must be called in `viewDidLayoutSubviews()` and `viewSafeAreaInsetsDidChange()` (if `viewKeyboardLayoutGuide.usesSafeArea` is `true`).
  /// It's automatically called when `keyboardWillChangeFrameNotification` changes.
  public func updateViewKeyboardLayoutGuideConstraints() {
    let frame: CGRect
    if viewKeyboardLayoutGuide.usesSafeArea {
      frame = view.bounds.inset(by: view.safeAreaInsets)
    } else {
      frame = view.bounds
    }
    var intersectionRect: CGRect
    if let keyboardWillChangeFrameNotification {
      let convertedKeyboardFrameEnd = keyboardWillChangeFrameNotification.convertedKeyboardFrameEnd(view)
      intersectionRect = frame.intersection(convertedKeyboardFrameEnd)
    } else {
      intersectionRect = frame
      intersectionRect.origin.y = frame.maxY
      intersectionRect.size.height = 0
    }
    viewKeyboardIntersectionRectDidChange(intersectionRect)
  }

  @objc open func viewKeyboardIntersectionRectDidChange(_ rect: CGRect) {
    viewKeyboardLayoutGuideHeightConstraint.constant = rect.height
  }

  // MARK: Observation

  public func observeKeyboard() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  public func unobserveKeyboard() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    keyboardWillChangeFrameNotification = nil
  }

  @objc private func keyboardWillChangeFrame(_ notification: Notification) {
    keyboardWillChangeFrameNotification = KeyboardNotification(notification)
  }
}
