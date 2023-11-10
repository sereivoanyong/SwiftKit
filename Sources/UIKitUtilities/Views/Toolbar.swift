//
//  Toolbar.swift
//
//  Created by Sereivoan Yong on 3/3/21.
//

import UIKit

@IBDesignable
open class Toolbar: UIToolbar {

  open var overrideBarPosition: UIBarPosition?

  open override var barPosition: UIBarPosition {
    return overrideBarPosition ?? super.barPosition
  }
}

extension Toolbar {

  @IBInspectable
  public var overrideBarPositionRaw: Int {
    get { return overrideBarPosition?.rawValue ?? -1 }
    set { overrideBarPosition = UIBarPosition(rawValue: newValue) }
  }
}
