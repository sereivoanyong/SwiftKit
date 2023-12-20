//
//  HostingView.swift
//
//  Created by Sereivoan Yong on 10/26/22.
//

import UIKit
import SwiftKit

open class HostingView<RootView: UIView>: UIView, HostingViewProtocol {

  open override func layoutSubviews() {
    super.layoutSubviews()

    if rootViewIfLoaded == nil {
      _ = rootView
    }
  }
}

extension HostingView: ContentConfiguring where RootView: ContentConfiguring {

}
