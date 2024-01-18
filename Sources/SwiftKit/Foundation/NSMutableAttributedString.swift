//
//  NSMutableAttributedString.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)

import Foundation

extension NSMutableAttributedString {

  @inlinable
  public static func += (lhs: NSMutableAttributedString, rhs: NSAttributedString) {
    lhs.append(rhs)
  }

  @inlinable
  public static func += (lhs: NSMutableAttributedString, rhs: String) {
    lhs.append(NSAttributedString(string: rhs))
  }
}

#endif
