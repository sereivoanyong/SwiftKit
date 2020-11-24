//
//  NSMutableAttributedString.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation

extension NSMutableAttributedString {
  
  public static func += (lhs: NSMutableAttributedString, rhs: NSAttributedString) {
    lhs.append(rhs)
  }
  
  public static func += (lhs: NSMutableAttributedString, rhs: String) {
    lhs += NSAttributedString(string: rhs)
  }
}
#endif
