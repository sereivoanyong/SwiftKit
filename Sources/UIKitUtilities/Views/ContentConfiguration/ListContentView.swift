//
//  ListContentView.swift
//
//  Created by Sereivoan Yong on 9/19/22.
//

import UIKit

/// Parent cell must be `CollectionViewListCell`
@available(iOS 14.0, *)
public protocol ListContentView: UIContentView {

  func makeConstraintsForSeparator(in cell: UICollectionViewListCell) -> [NSLayoutConstraint]
}

@available(iOS 14.0, *)
extension ListContentView {

  public func makeConstraintsForSeparator(in cell: UICollectionViewListCell) -> [NSLayoutConstraint] {
    return []
  }
}
