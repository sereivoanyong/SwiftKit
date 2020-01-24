//
//  UILabel.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UILabel {
  
  @inlinable public convenience init(text: String? = nil, font: UIFont, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil, numberOfLines: Int = 1) {
    self.init(frame: .zero)
    self.font = font
    self.textAlignment = textAlignment
    self.textColor = textColor
    self.numberOfLines = numberOfLines
    self.text = text
  }
}
#endif
