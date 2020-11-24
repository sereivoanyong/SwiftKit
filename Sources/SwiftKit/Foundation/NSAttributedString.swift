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
}

extension Collection where Element: NSAttributedString, Index == Int {
  
  public func joined(separator: String, attributes: [NSAttributedString.Key: Any]? = nil) -> NSMutableAttributedString {
    let attributedSeparator = NSAttributedString(string: separator, attributes: attributes)
    return enumerated().reduce(into: NSMutableAttributedString()) { result, pair in
      let (index, attributedString) = pair
      result.append(attributedString)
      if index < endIndex - 1 {
        result.append(attributedSeparator)
      }
    }
  }
}
#endif
