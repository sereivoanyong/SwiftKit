//
//  CollectionViewCell.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/23/25.
//

import UIKit

open class CollectionViewCell: UICollectionViewCell, AppearingCollectionReusableView {

  private var contentObservation: NSKeyValueObservation?

  open var appearanceState: AppearanceState = .none {
    didSet {
      if let contentView = contentView as? AppearingCollectionReusableViewSubview {
        contentView.parentReusableViewAppearanceStateDidChange(self)
      }
    }
  }

  open var overrideHeight: CGFloat?

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
  }

  open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
    var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    if let overrideHeight {
      size.height = overrideHeight
    }
    return size
  }
}
