//
//  UIRefreshControl.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIRefreshControl {

  public func beginRefreshingManually(animated: Bool) {
    beginRefreshing()
    let offsetPoint = CGPoint(x: 0, y: -frame.height)
    if let scrollView = superview as? UIScrollView {
      scrollView.setContentOffset(offsetPoint, animated: animated)
    }
  }
}
#endif
