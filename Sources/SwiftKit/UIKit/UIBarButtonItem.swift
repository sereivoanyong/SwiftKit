//
//  UIBarButtonItem.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UIBarButtonItem {
  
  public convenience init(systemItem: SystemItem) {
    self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
  }
  
  final public var view: UIView? {
    get { return value(forKey: "view") as? UIView }
    set { setValue(newValue, forKey: "view") }
  }
  
  final public func set(target: AnyObject?, action: Selector?) {
    self.target = target
    self.action = action
  }
  
  public static var flexibleSpace: UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  }
  
  public static func fixedSpace(width: CGFloat) -> UIBarButtonItem {
    let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    barButtonItem.width = width
    return barButtonItem
  }
}
#endif
