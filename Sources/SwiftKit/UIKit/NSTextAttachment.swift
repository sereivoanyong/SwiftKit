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

extension NSAttributedString {
  
  @inlinable public static func + (lhs: NSAttributedString, rhs: NSTextAttachment) -> NSMutableAttributedString {
    return lhs + NSAttributedString(attachment: rhs)
  }
  
  public static func attachment(data: Data?, uti: String?) -> NSAttributedString {
    return NSAttributedString(attachment: NSTextAttachment(data: data, ofType: uti))
  }
  
  public static func attachment(image: UIImage?) -> NSAttributedString {
    return NSAttributedString(attachment: NSTextAttachment(image: image))
  }
}
#endif
