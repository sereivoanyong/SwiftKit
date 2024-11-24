//
//  HostingCollectionViewListCell.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
open class HostingCollectionViewListCell<RootView: UIView>: UICollectionViewListCell, HostingViewCell, AppearingCollectionReusableView {

  open var appearanceState: AppearanceState = .none {
    didSet {
      if let rootView = rootView as? AppearingCollectionReusableViewSubview {
        rootView.parentReusableViewAppearanceStateDidChange(self)
      }
    }
  }

  open var isSeparatorConfigured: Bool = false

  open override func layoutSubviews() {
    super.layoutSubviews()

    if rootViewIfLoaded == nil {
      _ = rootView
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()

    appearanceState = .none
    if let rootView = rootViewIfLoaded as? ReusableView {
      rootView.prepareForReuse()
    }
  }
}

@available(iOS 14.0, *)
extension HostingCollectionViewListCell: ContentConfiguring where RootView: ContentConfiguring {

}
