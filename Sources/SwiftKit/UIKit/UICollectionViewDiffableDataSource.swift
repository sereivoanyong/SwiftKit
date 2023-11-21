//
//  UICollectionViewDiffableDataSource.swift
//
//  Created by Sereivoan Yong on 11/24/23.
//

import UIKit

@available(iOS 13.0, *)
extension UICollectionViewDiffableDataSource {

  @backDeployed(before: iOS 15.0)
  final public func sectionIdentifier(for index: Int) -> SectionIdentifierType? {
    return snapshot().sectionIdentifiers[index]
  }
}
