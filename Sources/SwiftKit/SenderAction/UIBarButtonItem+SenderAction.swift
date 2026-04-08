//
//  UIBarButtonItem+SenderAction.swift
//
//  Created by Sereivoan Yong on 6/19/21.
//

import UIKit

private var senderActionKey: Void?

extension BackwardCompatibility where Base: UIBarButtonItem {

  @MainActor public var senderAction: SenderAction<UIBarButtonItem>? {
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

  @MainActor public var handler: (@MainActor (UIBarButtonItem) -> Void)? {
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

extension UIBarButtonItem: BackwardCompatible {

  public convenience init(systemItem: SystemItem, handler: @escaping @MainActor (UIBarButtonItem) -> Void) {
    self.init(systemItem: systemItem, target: nil, action: nil)
    bc.handler = handler
  }

  public convenience init(title: String? = nil, image: UIImage? = nil, handler: @escaping @MainActor (UIBarButtonItem) -> Void) {
    self.init()
    self.title = title
    self.image = image
    bc.handler = handler
  }
}
