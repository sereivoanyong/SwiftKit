//
//  UIActivityIndicatorView.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIActivityIndicatorView.Style {
  
  public static var grayOrMedium: UIActivityIndicatorView.Style {
    if #available(iOS 13.0, *) {
      return medium
    } else {
      return gray
    }
  }
}
#endif
