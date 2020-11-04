//
//  UITextView.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UITextView {
  
  @inlinable public convenience init(text: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil) {
    self.init(frame: .zero)
    self.font = font
    self.textAlignment = textAlignment
    #if swift(>=5.3)
    self.textColor = textColor ?? .label()
    #else
    self.textColor = textColor ?? .preferredLabel
    #endif
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
