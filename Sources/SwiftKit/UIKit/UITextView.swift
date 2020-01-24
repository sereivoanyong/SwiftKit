//
//  UITextView.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UITextView {
  
  public convenience init(text: String?, font: UIFont, textAlignment: NSTextAlignment = .left, textColor: UIColor? = nil) {
    self.init(frame: .zero)
    self.font = font
    self.textAlignment = textAlignment
    self.textColor = textColor
    self.text = text
  }
  
  final public func inheritLabelBehavior() {
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
#endif
