//
//  CollectionViewListCell.swift
//
//  Created by Sereivoan Yong on 9/19/22.
//

import UIKit

@available(iOS 14.0, *)
open class CollectionViewListCell: UICollectionViewListCell {

  open var constraintsForSeparator: [NSLayoutConstraint] = [] {
    didSet {
      NSLayoutConstraint.deactivate(oldValue)
      NSLayoutConstraint.activate(constraintsForSeparator)
    }
  }

  open override func updateConfiguration(using state: UICellConfigurationState) {
    super.updateConfiguration(using: state)

    if let contentView = contentView as? ListContentView {
      constraintsForSeparator = contentView.makeConstraintsForSeparator(in: self)
    }
//    else {
//      constraintsForSeparator = [layoutMarginsGuide.trailingAnchor.constraint(equalTo: separatorLayoutGuide.trailingAnchor)]
//    }
  }
}
