//
//  NSAttributedString.swift
//
//  Created by Sereivoan Yong on 8/22/20.
//

#if canImport(UIKit)

import UIKit

extension NSAttributedString {

  @inlinable
  public static func space(_ width: CGFloat) -> NSAttributedString {
    /* Tested and works on iOS 18 and 26 but does not work on 16.
    var attchmentCharacter: unichar = 0xFFFC // NSTextAttachment.character
    let nonPrintableString = String(utf16CodeUnits: &attchmentCharacter, count: 1) // This can be anything non-printable
    return NSAttributedString(string: nonPrintableString, attributes: [.kern: width._bridgeToObjectiveC()])
     */

    let attachment = NSTextAttachment()
    attachment.bounds = CGRect(x: 0, y: 0, width: width, height: 0)
    return NSAttributedString(attachment: attachment)
  }
}

#endif

#if canImport(Foundation)

extension NSAttributedString {

  @inlinable
  public static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
    let result = NSMutableAttributedString(attributedString: lhs)
    result.append(rhs)
    return result
  }

  @inlinable
  public static func + (lhs: NSAttributedString, rhs: String) -> NSMutableAttributedString {
    let result = NSMutableAttributedString(attributedString: lhs)
    result.append(NSAttributedString(string: rhs))
    return result
  }
}

extension String {

  @inlinable
  public func attributed(attributes: [NSAttributedString.Key: Any]? = nil) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: self, attributes: attributes)
  }
}

extension Sequence {

  // https://github.com/apple/swift/blob/dd3f6ef2a67a6b6caf3c71f93098b164550d2756/stdlib/public/core/String.swift#L788
  @inlinable
  public func joined(separator: NSAttributedString) -> NSMutableAttributedString where Element: NSAttributedString {
    let result = NSMutableAttributedString()
    if separator.length == 0 {
      for element in self {
        result.append(element)
      }
      return result
    }

    var iterator = makeIterator()
    if let first = iterator.next() {
      result.append(first)
      while let next = iterator.next() {
        result.append(separator)
        result.append(next)
      }
    }
    return result
  }

  public func attributedJoined(attributes: [NSAttributedString.Key: Any]? = nil, attributedSeparator: NSAttributedString) -> NSMutableAttributedString where Element == String {
    return map { NSAttributedString(string: $0, attributes: attributes) }.joined(separator: attributedSeparator)
  }

  public func attributedJoined(separator: String, attributes: [NSAttributedString.Key: Any]? = nil) -> NSMutableAttributedString where Element == String {
    return attributedJoined(attributes: attributes, attributedSeparator: NSAttributedString(string: separator, attributes: attributes))
  }
}

#endif
