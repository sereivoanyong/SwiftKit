//
//  UILabel.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UILabel {
  
  @inlinable public convenience init(text: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil, numberOfLines: Int = 1) {
    self.init(frame: .zero)
    self.font = font
    self.textAlignment = textAlignment
    #if swift(>=5.3)
    self.textColor = textColor ?? .label()
    #else
    self.textColor = textColor ?? .preferredLabel
    #endif
    self.numberOfLines = numberOfLines
    self.text = text
  }
}
#endif
