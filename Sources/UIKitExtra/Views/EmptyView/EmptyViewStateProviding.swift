//
//  EmptyViewStateProviding.swift
//
//  Created by Sereivoan Yong on 4/30/21.
//

#if os(iOS)

import UIKit

public protocol EmptyViewStateProviding: AnyObject {

  func state(for emptyView: EmptyView) -> EmptyView.State?
}

extension EmptyViewStateProviding where Self: UIView {

  func reloadEmptyViewIfPossible() {
    if let emptyView = emptyView {
      emptyView.reload()
    }
  }
}

extension UICollectionView: EmptyViewStateProviding {

  public func state(for emptyView: EmptyView) -> EmptyView.State? {
    for section in 0..<numberOfSections {
      if numberOfItems(inSection: section) > 0 {
        return nil
      }
    }
    if let stateProvider = emptyView.stateProvider, stateProvider !== self {
      return stateProvider.state(for: emptyView)
    }
    return .empty
  }
}

extension UITableView: EmptyViewStateProviding {

  public func state(for emptyView: EmptyView) -> EmptyView.State? {
    for section in 0..<numberOfSections {
      if numberOfRows(inSection: section) > 0 {
        return nil
      }
    }
    if let stateProvider = emptyView.stateProvider, stateProvider !== self {
      return stateProvider.state(for: emptyView)
    }
    return .empty
  }
}

#endif
