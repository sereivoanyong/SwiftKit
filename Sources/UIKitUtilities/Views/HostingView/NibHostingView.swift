//
//  NibHostingView.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit

open class NibHostingView: UIView, HostingViewProtocol {

  @IBInspectable open var rootViewNibName: String!

  open var rootViewBundle: Bundle?

  open func makeRootView() -> UIView {
    return UINib(nibName: rootViewNibName, bundle: rootViewBundle).instantiate(withOwner: nil)[0] as! UIView
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    if rootViewIfLoaded == nil {
      _ = rootView
    }
  }
}
