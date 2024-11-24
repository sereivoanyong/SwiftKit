//
//  HostingCollectionViewCell.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit
import SwiftKit

open class HostingCollectionViewCell<RootView: UIView>: UICollectionViewCell, HostingViewCell, AppearingCollectionReusableView {

  open var appearanceState: AppearanceState = .none {
    didSet {
      if let rootView = rootView as? AppearingCollectionReusableViewSubview {
        rootView.parentReusableViewAppearanceStateDidChange(self)
      }
    }
  }

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

extension HostingCollectionViewCell: ContentConfiguring where RootView: ContentConfiguring {

}
