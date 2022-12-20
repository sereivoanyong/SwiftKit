//
//  UIAction.swift
//
//  Created by Sereivoan Yong on 2/19/22.
//

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, *)
extension UIAction {

  public var handler: UIActionHandler {
    typealias Block = @convention(block) (UIAction) -> Void
    let handler = value(forKey: "handler") as AnyObject
    return unsafeBitCast(handler, to: Block.self)
  }
}
#endif
