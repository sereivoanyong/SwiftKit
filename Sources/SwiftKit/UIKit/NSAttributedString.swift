//
//  NSAttributedString.swift
//
//  Created by Sereivoan Yong on 8/22/20.
//

#if canImport(UIKit)
import UIKit

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
