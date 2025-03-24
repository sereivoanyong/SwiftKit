//
//  ModernCollectionViewListController.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/25/25.
//

import UIKit

@available(iOS 15.0, *)
open class ModernCollectionViewListController<SectionIdentifier: Hashable, ItemIdentifier: Hashable>: ModernCollectionViewController<SectionIdentifier, ItemIdentifier> {

  public typealias ListDataSource = CollectionViewDiffableListDataSource<ListSection<SectionIdentifier>, ListItem<ItemIdentifier>>

  public typealias ListDataSourceSnapshot = DiffableListDataSourceSnapshot<ListSection<SectionIdentifier>, ListItem<ItemIdentifier>>

  public typealias ListDataSourceSectionSnapshot = DiffableListDataSourceSectionSnapshot<ListItem<ItemIdentifier>>

  @inlinable
  open override var dataSource: ListDataSource! {
    return unsafeDowncast(super.dataSource, to: ListDataSource.self)
  }

  open override func makeDataSource() -> UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier> {
    let dataSource = ListDataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, itemIdentifier in
      return cell(in: collectionView, at: indexPath, for: itemIdentifier)
    }
    dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
      guard let sectionIdentifier = self.dataSource.sectionIdentifier(for: indexPath.section) else { return nil }
      let kind = UICollectionView.ElementKind(kind)
      return supplementaryView(in: collectionView, of: kind, at: indexPath, for: sectionIdentifier)
    }
    return dataSource
  }

  open override func listSection(at index: Int, for identifier: SectionIdentifier) -> ListSection<SectionIdentifier>? {
    return dataSource.section(for: index)
  }

  open override func listItem(at indexPath: IndexPath, for identifier: ItemIdentifier) -> ListItem<ItemIdentifier> {
    return dataSource.item(for: indexPath)!
  }
}
