//
//  UIUserInterfaceIdiom.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/7/25.
//

import UIKit

extension UIUserInterfaceIdiom {

  public var isPadOrMac: Bool {
    switch self {
    case .pad, .mac:
      return true
    default:
      return false
    }
  }
}
