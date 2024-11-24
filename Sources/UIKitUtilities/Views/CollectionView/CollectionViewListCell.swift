//
//  CollectionViewListCell.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/23/24.
//

import UIKit

@available(iOS 14.0, *)
open class CollectionViewListCell: UICollectionViewListCell, AppearingCollectionReusableView {

  private var contentObservation: NSKeyValueObservation?

  open var appearanceState: AppearanceState = .none {
    didSet {
      if let contentView = contentView as? AppearingCollectionReusableViewSubview {
        contentView.parentReusableViewAppearanceStateDidChange(self)
      }
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    contentObservation = observe(\.contentView) { cell, change in
      cell.contentViewDidChange(change.oldValue)
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()
    
    appearanceState = .none
  }

  open func contentViewDidChange(_ oldContentView: UIView?) {
    let contentView = contentView
    guard contentView !== oldContentView else { return }
    if let contentView = contentView as? ListContentView {
      let primaryContentAnchors = contentView.primaryContentAnchorsForSeparator
      NSLayoutConstraint.activate([
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: primaryContentAnchors.leading),
        primaryContentAnchors.trailing.constraint(equalTo: separatorLayoutGuide.trailingAnchor),
      ])
    }
  }
}
