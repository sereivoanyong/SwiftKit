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
  
  final public func setTarget(_ target: AnyObject?, action: Selector?) {
    self.target = target
    self.action = action
  }

  // MARK: Action Support

  public convenience init(systemItem: SystemItem, handler: ((UIBarButtonItem) -> Void)? = nil) {
    self.init(systemItem: systemItem, target: nil, action: nil)
    self.handler = handler
  }

  public convenience init(title: String? = nil, image: UIImage? = nil, style: Style = .plain, handler: ((UIBarButtonItem) -> Void)? = nil) {
    self.init(title: title, image: image, style: style, target: nil, action: nil)
    self.handler = handler
  }

  private static var actionKey: Void?
  final public var handler: ((UIBarButtonItem) -> Void)? {
    get {
      if let action = associatedObject(forKey: &Self.actionKey) as Action<UIBarButtonItem>?, case .sender(let handler) = action.handler {
        return handler
      }
      return nil
    }
    set {
      if let newValue = newValue {
        if let action = associatedObject(forKey: &Self.actionKey) as Action<UIBarButtonItem>? {
          action.handler = .sender(newValue)
        } else {
          let action = Action<UIBarButtonItem>(handler: newValue)
          setTarget(action, action: #selector(Action<UIBarButtonItem>.invoke(_:)))
          setAssociatedObject(action, forKey: &Self.actionKey)
        }
      } else {
        if let action = associatedObject(forKey: &Self.actionKey) as Action<UIBarButtonItem>? {
          if self.target === action && self.action == #selector(Action<UIBarButtonItem>.invoke(_:)) {
            setTarget(nil, action: nil)
          }
        }
        setAssociatedObject(nil as Action<UIBarButtonItem>?, forKey: &Self.actionKey)
      }
    }
  }
}
#endif
