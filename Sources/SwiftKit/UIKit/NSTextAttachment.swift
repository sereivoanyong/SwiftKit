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
  
  public static func attachment(_ attachment: NSTextAttachment) -> NSAttributedString {
    return NSAttributedString(attachment: attachment)
  }
  
  public static func attachment(data: Data?, uti: String?) -> NSAttributedString {
    return attachment(NSTextAttachment(data: data, ofType: uti))
  }
  
  public static func attachment(image: UIImage?) -> NSAttributedString {
    return attachment(NSTextAttachment(image: image))
  }
}
#endif
