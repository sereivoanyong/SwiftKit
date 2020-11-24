//
//  UITextField.swift
//
//  Created by Sereivoan Yong on 1/27/20.
//

#if canImport(UIKit)
import UIKit

extension UITextField {
  
  @inlinable public convenience init(text: String? = nil, placeholder: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .left, textColor: UIColor? = nil) {
    self.init(frame: .zero)
    self.font = font
    self.textAlignment = textAlignment
    self.textColor = textColor ?? .label()
    self.text = text
    self.placeholder = placeholder
  }
}
#endif
