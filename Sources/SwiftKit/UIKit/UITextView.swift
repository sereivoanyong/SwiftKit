//
//  UITextView.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UITextView {

  @inlinable
  public convenience init(text: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil) {
    self.init(frame: .zero)
    self.font = font
    self.textAlignment = textAlignment
    self.textColor = textColor ?? .label()
    self.text = text
  }

  public func configureAsLabel() {
    isEditable = false
    isSelectable = false
    isScrollEnabled = false
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    alwaysBounceHorizontal = false
    alwaysBounceVertical = false
    bounces = false
    bouncesZoom = false
  }
}
