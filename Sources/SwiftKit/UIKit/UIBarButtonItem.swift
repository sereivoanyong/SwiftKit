//
//  UIBarButtonItem.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UIBarButtonItem {
  
  @inlinable public convenience init(systemItem: SystemItem, target: AnyObject? = nil, action: Selector? = nil) {
    self.init(barButtonSystemItem: systemItem, target: target, action: action)
  }
  
  @inlinable public convenience init(title: String? = nil, image: UIImage? = nil, style: Style = .plain, target: AnyObject? = nil, action: Selector? = nil) {
    self.init()
    self.title = title
    self.image = image
    self.style = style
    self.target = target
    self.action = action
  }
  
  public static func fixedSpace(_ width: CGFloat) -> Self {
    let barButtonItem = Self(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    barButtonItem.width = width
    return barButtonItem
  }
  
  public static func flexibleSpace() -> Self {
    return Self(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  }
  
  final public var view: UIView? {
    get { return value(forKey: "view") as? UIView }
    set { setValue(newValue, forKey: "view") }
  }
  
  final public func set(target: AnyObject?, action: Selector?) {
    self.target = target
    self.action = action
  }
}
#endif
