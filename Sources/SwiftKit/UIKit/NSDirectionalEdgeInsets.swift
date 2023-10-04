//
//  NSDirectionalEdgeInsets.swift
//
//  Created by Sereivoan Yong on 10/4/23.
//

import UIKit

extension NSDirectionalEdgeInsets {

  public func resolved(with layoutDirection: UIUserInterfaceLayoutDirection) -> UIEdgeInsets {
    if layoutDirection == .rightToLeft {
      return UIEdgeInsets(top: top, left: trailing, bottom: bottom, right: leading)
    } else {
      return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
  }
}
