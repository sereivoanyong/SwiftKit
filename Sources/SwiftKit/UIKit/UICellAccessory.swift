//
//  UICellAccessory.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/24/25.
//

import UIKit

@available(iOS 14.0, *)
extension UICellAccessory {

  public static func customView(_ customView: UIView, placement: Placement, isHidden: Bool? = nil, reservedLayoutWidth: LayoutDimension? = nil, tintColor: UIColor? = nil, maintainsFixedSize: Bool? = nil) -> Self {
    let configuration = CustomViewConfiguration(customView: customView, placement: placement, isHidden: isHidden, reservedLayoutWidth: reservedLayoutWidth, tintColor: tintColor, maintainsFixedSize: maintainsFixedSize)
    return self.customView(configuration: configuration)
  }
}
