//
//  NSMutableParagraphStyle.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension NSMutableParagraphStyle {
  
  @inlinable
  public convenience init(lineSpacing: CGFloat = 0, paragraphSpacing: CGFloat = 0, alignment: NSTextAlignment = .natural) {
    self.init()
    self.lineSpacing = lineSpacing
    self.paragraphSpacing = paragraphSpacing
    self.alignment = alignment
  }
}
