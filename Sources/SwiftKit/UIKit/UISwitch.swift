//
//  UISwitch.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UISwitch {
  
  public convenience init(target: AnyObject, action: Selector) {
    self.init(frame: .zero)
    addTarget(target, action: action, for: .valueChanged)
  }
  
  /// Toggle the state of the switch to On or Off, optionally animating the transition
  final public func toggleOn(animated: Bool) {
    setOn(!isOn, animated: animated)
  }
}
#endif
