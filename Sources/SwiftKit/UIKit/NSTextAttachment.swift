//
//  NSTextAttachment.swift
//
//  Created by Sereivoan Yong on 11/23/20.
//

#if canImport(UIKit)
import UIKit

extension NSTextAttachment {
  
  public convenience init(image: UIImage?) {
    self.init()
    self.image = image
  }
}
#endif
