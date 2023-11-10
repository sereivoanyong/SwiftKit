//
//  UIContextMenuInteraction.swift
//
//  Created by Sereivoan Yong on 11/10/23.
//

import UIKit

@available(iOS 13.0, *)
extension UIContextMenuInteraction {

  public func presentMenu(at location: CGPoint) {
    let selector = Selector(("_presentMenuAtLocation:"))
    if responds(to: selector) {
      perform(selector, with: location)
    }
  }
}
