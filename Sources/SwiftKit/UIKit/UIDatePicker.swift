//
//  UIDatePicker.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UIDatePicker {

  public var textColor: UIColor? {
    get { return value(forKey: "textColor") as? UIColor }
    set { setValue(newValue, forKey: "textColor") }
  }
}
