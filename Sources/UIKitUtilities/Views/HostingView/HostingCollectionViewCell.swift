//
//  HostingCollectionViewCell.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit
import SwiftKit

open class HostingCollectionViewCell<RootView: UIView>: UICollectionViewCell, HostingCollectionViewCellProtocol {

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

extension HostingCollectionViewCell: ContentConfiguring where RootView: ContentConfiguring {

}
