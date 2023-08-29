//
//  UIBarButtonItem+SenderAction.swift
//
//  Created by Sereivoan Yong on 6/19/21.
//

import UIKit

private var senderActionKey: Void?
extension BackwardCompatibility where Base: UIBarButtonItem {

  public var senderAction: SenderAction<UIBarButtonItem>? {
    get { return associatedObject(forKey: &senderActionKey, with: base) }
    nonmutating set {
      if let newValue {
        base.target = newValue
        base.action = #selector(SenderAction<UIBarButtonItem>.invoke(_:))
      } else {
        if base.target is SenderAction<UIBarButtonItem> {
          base.action = nil
        }
      }
      setAssociatedObject(newValue, forKey: &senderActionKey, with: base)
    }
  }

  public var handler: ((UIBarButtonItem) -> Void)? {
    get { return senderAction?.handler }
    nonmutating set {
      if let newValue {
        if let senderAction {
          senderAction.handler = newValue
        } else {
          senderAction = SenderAction<UIBarButtonItem>(handler: newValue)
        }
      } else {
        senderAction = nil
      }
    }
  }
}

extension UIBarButtonItem: BackwardCompatible { }

extension UIBarButtonItem {

  public convenience init(image: UIImage?, style: Style, handler: ((UIBarButtonItem) -> Void)?) {
    self.init(image: image, style: style, target: nil, action: nil)
    bc.handler = handler
  }

  public convenience init(title: String?, style: Style, handler: ((UIBarButtonItem) -> Void)?) {
    self.init(title: title, style: style, target: nil, action: nil)
    bc.handler = handler
  }

  public convenience init(systemItem: SystemItem, handler: ((UIBarButtonItem) -> Void)?) {
    self.init(systemItem: systemItem, target: nil, action: nil)
    bc.handler = handler
  }

  @available(*, deprecated, message: "Use `bc.senderAction` instead.")
  public var senderAction: SenderAction<UIBarButtonItem>? {
    get { return bc.senderAction }
    set { bc.senderAction = newValue }
  }

  @available(*, deprecated, message: "Use `bc.handler` instead.")
  public var handler: ((UIBarButtonItem) -> Void)? {
    get { return bc.handler }
    set { bc.handler = newValue }
  }
}
