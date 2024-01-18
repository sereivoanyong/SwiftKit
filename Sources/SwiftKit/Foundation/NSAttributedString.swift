//
//  NSAttributedString.swift
//
//  Created by Sereivoan Yong on 8/22/20.
//

#if canImport(Foundation)

import Foundation

extension NSAttributedString {

  public static func space<Number>(_ width: Number) -> NSAttributedString where Number: _ObjectiveCBridgeable, Number._ObjectiveCType: NSNumber {
    var attchmentCharacter: unichar = 0xFFFC // NSTextAttachment.character
    let nonPrintableString = String(utf16CodeUnits: &attchmentCharacter, count: 1) // This can be anything non-printable
    return NSAttributedString(string: nonPrintableString, attributes: [.kern: width._bridgeToObjectiveC()])
  }

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
