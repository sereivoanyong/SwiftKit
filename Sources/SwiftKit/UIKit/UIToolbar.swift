//
//  UIToolbar.swift
//
//  Created by Sereivoan Yong on 8/8/20.
//

import UIKit

extension UIToolbar {
  
  @inlinable 
  public convenience init(frame: CGRect = .zero, items: [UIBarButtonItem]? = nil) {
    self.init(frame: frame)
    self.items = items
  }
}
