//
//  HostingCollectionViewListCell.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
open class HostingCollectionViewListCell<RootView: UIView>: UICollectionViewListCell, HostingViewCell {

  open var isSeparatorConfigured: Bool = false

  open override func layoutSubviews() {
    super.layoutSubviews()

    if rootViewIfLoaded == nil {
      _ = rootView
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()

    if let rootView = rootViewIfLoaded as? Reusable {
      rootView.prepareForReuse()
    }
  }
}

@available(iOS 14.0, *)
extension HostingCollectionViewListCell: ContentConfiguring where RootView: ContentConfiguring {

}
