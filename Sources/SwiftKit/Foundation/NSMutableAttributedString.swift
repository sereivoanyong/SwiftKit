//
//  NSMutableAttributedString.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation

extension NSMutableAttributedString {
  
  public static func += (lhs: NSMutableAttributedString, rhs: NSAttributedString) {
    return lhs.append(rhs)
  }
  
  public static func += (lhs: NSMutableAttributedString, rhs: String) {
    return lhs.append(NSAttributedString(string: rhs))
  }
}
#endif
