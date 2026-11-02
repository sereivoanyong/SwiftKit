//
//  UIContextualAction.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/3/26.
//

import UIKit

extension UIContextualAction {

  @inlinable
  public convenience init(style: Style, title: String?, image: UIImage? = nil, backgroundColor: UIColor? = nil, handler: @escaping Handler) {
    self.init(style: style, title: title, handler: handler)
    self.image = image
    self.backgroundColor = backgroundColor
  }
}
