//
//  CollectionViewDiffableListDataSource.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/25/25.
//

import UIKit
import SwiftKit

@available(iOS 15.0, *)
open class CollectionViewDiffableListDataSource<Section: Identifiable, Item: Identifiable>: UICollectionViewDiffableDataSource<Section.ID, Item.ID> {

  public typealias Snapshot = DiffableListDataSourceSnapshot<Section, Item>

  public typealias SectionSnapshot = DiffableListDataSourceSectionSnapshot<Item>

  @usableFromInline
  var _sections: [Section.ID: Section] = [:]

  @usableFromInline
  var _items: [Item.ID: Item] = [:]

  // MARK: Public

  open func section(for index: Int) -> Section? {
    guard let identifier = sectionIdentifier(for: index) else { return nil }
    return _sections[identifier]!
  }

  open func item(for indexPath: IndexPath) -> Item? {
    guard let identifier = itemIdentifier(for: indexPath) else { return nil }
    return _items[identifier]!
  }

  // MARK: Sections

  open func apply(_ snapshot: Snapshot, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
    _sections.merge(snapshot._sections)
    _items.merge(snapshot._items)
    super.apply(snapshot.base, animatingDifferences: animatingDifferences, completion: completion)
  }

  open func applyUsingReloadData(_ snapshot: Snapshot, completion: (() -> Void)? = nil) {
    _sections.merge(snapshot._sections)
    _items.merge(snapshot._items)
    super.applySnapshotUsingReloadData(snapshot.base, completion: completion)
  }

  open func snapshot() -> Snapshot {
    let snapshot = super.snapshot()
    return .init(base: snapshot, sections: _sections, items: _items)
  }

  // MARK: Per Section

  open func apply(_ snapshot: SectionSnapshot, to sectionIdentifier: Section.ID, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
    _items.merge(snapshot._items)
    super.apply(snapshot.base, to: sectionIdentifier, animatingDifferences: animatingDifferences, completion: completion)
  }

  open func snapshot(for sectionIdentifier: Section.ID) -> SectionSnapshot {
    let sectionSnapshot = super.snapshot(for: sectionIdentifier)
    let sectionItems = sectionSnapshot.items.reduce(into: [Item.ID: Item](), { $0[$1] = _items[$1] })
    return .init(base: sectionSnapshot, items: sectionItems)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  open override func apply(_ snapshot: NSDiffableDataSourceSnapshot<Section.ID, Item.ID>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
    super.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
  }

  @available(*, unavailable)
  open override func apply(_ snapshot: NSDiffableDataSourceSnapshot<Section.ID, Item.ID>, animatingDifferences: Bool = true) async {
    await super.apply(snapshot, animatingDifferences: animatingDifferences)
  }

  @available(*, unavailable)
  open override func applySnapshotUsingReloadData(_ snapshot: NSDiffableDataSourceSnapshot<Section.ID, Item.ID>, completion: (() -> Void)? = nil) {
    super.applySnapshotUsingReloadData(snapshot, completion: completion)
  }

  @available(*, unavailable)
  open override func applySnapshotUsingReloadData(_ snapshot: NSDiffableDataSourceSnapshot<Section.ID, Item.ID>) async {
    await super.applySnapshotUsingReloadData(snapshot)
  }

  @available(*, unavailable)
  open override func snapshot() -> NSDiffableDataSourceSnapshot<Section.ID, Item.ID> {
    super.snapshot()
  }

  // MARK: Unavailable Overriden

  /*
  open override func apply(_ snapshot: NSDiffableDataSourceSectionSnapshot<Item.ID>, to section: SectionIdentifierType, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
    super.apply(snapshot, to: section, animatingDifferences: animatingDifferences, completion: completion)
  }

  open override func apply(_ snapshot: NSDiffableDataSourceSectionSnapshot<Item.ID>, to section: SectionIdentifierType, animatingDifferences: Bool = true) async {
    super.apply(snapshot, to: section, animatingDifferences: animatingDifferences)
  }

  open override func snapshot(for section: SectionIdentifierType) -> NSDiffableDataSourceSectionSnapshot<Item.ID> {
    return super.snapshot(for: section)
  }
   */
}
