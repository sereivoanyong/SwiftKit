//
//  UICollectionViewCell.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit

extension UICollectionViewCell {

  public func preserveSuperviewLayoutMargins() {
    if !preservesSuperviewLayoutMargins {
      preservesSuperviewLayoutMargins = true
    }
    if !contentView.preservesSuperviewLayoutMargins {
      contentView.preservesSuperviewLayoutMargins = true
    }
  }
}
