//
//  HostingTableViewCell.swift
//
//  Created by Sereivoan Yong on 5/7/24.
//

import UIKit
import SwiftKit

open class HostingTableViewCell<RootView: UIView>: UITableViewCell, HostingViewCell {

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

extension HostingTableViewCell: ContentConfiguring where RootView: ContentConfiguring {

}
