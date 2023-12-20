//
//  HostingCollectionViewCell.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit
import SwiftKit

open class HostingCollectionViewCell<RootView: UIView>: UICollectionViewCell, HostingViewProtocol {

  open override func layoutSubviews() {
    super.layoutSubviews()

    if rootViewIfLoaded == nil {
      _ = rootView
    }
  }
}

extension HostingCollectionViewCell: ContentConfiguring where RootView: ContentConfiguring { 

}
