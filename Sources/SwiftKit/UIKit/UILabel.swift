//
//  UILabel.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UILabel {
  
  @inlinable
  public convenience init(text: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil, numberOfLines: Int = 1) {
    self.init(frame: .zero)
    self.font = font
    self.textAlignment = textAlignment
    self.textColor = textColor ?? .label()
    self.numberOfLines = numberOfLines
    self.text = text
  }
}
