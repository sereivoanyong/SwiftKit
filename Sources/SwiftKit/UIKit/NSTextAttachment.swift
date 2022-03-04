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

  // https://stackoverflow.com/a/69119772/11235826
  public static func fixedSpace(_ width: CGFloat) -> NSTextAttachment {
    let attachment = NSTextAttachment()
    attachment.bounds.size.width = width
    return attachment
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
