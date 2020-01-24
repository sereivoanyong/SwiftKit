//
//  UINavigationBar.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UINavigationBar {
  
  final public var backgroundView: UIView? {
    get { return value(forKey: "backgroundView") as? UIView }
    set { setValue(newValue, forKey: "backgroundView") }
  }
  
  final public var hidesShadow: Bool {
    get { return value(forKey: "hidesShadow") as? Bool ?? false }
    set { setValue(newValue as NSNumber, forKey: "hidesShadow") }
  }
}
#endif
