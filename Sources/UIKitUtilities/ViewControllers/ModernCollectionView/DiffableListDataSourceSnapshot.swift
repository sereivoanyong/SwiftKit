//
//  DiffableListDataSourceSnapshot.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/25/25.
//

import UIKit

@available(iOS 15.0, *)
public struct DiffableListDataSourceSnapshot<Section: Identifiable, Item: Identifiable> {

  @usableFromInline
  var base: NSDiffableDataSourceSnapshot<Section.ID, Item.ID>

  @usableFromInline
  var _sections: [Section.ID: Section]

  @usableFromInline
  var _items: [Item.ID: Item]

  public var sections: [Section] {
    return sectionIdentifiers.map { _sections[$0]! }
  }

  public var sectionIdentifiers: [Section.ID] {
    return base.sectionIdentifiers
  }

  public var items: [Item] {
    return itemIdentifiers.map { _items[$0]! }
  }

  public var itemIdentifiers: [Item.ID] {
    return base.itemIdentifiers
  }

  init(base: NSDiffableDataSourceSnapshot<Section.ID, Item.ID>, sections: [Section.ID: Section], items: [Item.ID: Item]) {
    assert(base.sectionIdentifiers.count == sections.count)
    assert(base.itemIdentifiers.count == items.count)
    self.base = base
    self._sections = sections
    self._items = items
  }

  public init() {
    base = .init()
    _sections = [:]
    _items = [:]
  }

  public mutating func appendItems(_ items: [Item], toSection sectionIdentifier: Section.ID? = nil) {
    base.appendItems(items.map(\.id), toSection: sectionIdentifier)
    for item in items {
      _items[item.id] = item
    }
  }

  public mutating func insertItems(_ items: [Item], beforeItem beforeItemIdentifier: Item.ID) {
    base.insertItems(items.map(\.id), beforeItem: beforeItemIdentifier)
    for item in items {
      _items[item.id] = item
    }
  }

  public mutating func insertItems(_ items: [Item], afterItem afterItemIdentifier: Item.ID) {
    base.insertItems(items.map(\.id), afterItem: afterItemIdentifier)
    for item in items {
      _items[item.id] = item
    }
  }

  public mutating func deleteItems(_ itemIdentifiers: [Item.ID]) {
    base.deleteItems(itemIdentifiers)
    for itemIdentifier in itemIdentifiers {
      _items[itemIdentifier] = nil
    }
  }

  public mutating func deleteAll() {
    base.deleteAllItems() // Bad documenting from Apple. This actually delete both sections and items.
    _sections.removeAll()
    _items.removeAll()
  }

  public mutating func moveItem(_ itemIdentifier: Item.ID, beforeItem toItemIdentifier: Item.ID) {
    base.moveItem(itemIdentifier, beforeItem: toItemIdentifier)
  }

  public mutating func moveItem(_ itemIdentifier: Item.ID, afterItem toItemIdentifier: Item.ID) {
    base.moveItem(itemIdentifier, afterItem: toItemIdentifier)
  }

  public mutating func reloadItemIdentifiers(_ itemIdentifiers: [Item.ID]) {
    base.reloadItems(itemIdentifiers)
  }

  public mutating func reloadItems(_ items: [Item]) {
    base.reloadItems(items.map(\.id))
    for item in items {
      _items[item.id] = item
    }
  }

  public mutating func reconfigureItemIdentifiers(_ itemIdentifiers: [Item.ID]) {
    base.reconfigureItems(itemIdentifiers)
  }

  public mutating func reconfigureItems(_ items: [Item]) {
    base.reconfigureItems(items.map(\.id))
    for item in items {
      _items[item.id] = item
    }
  }

  public mutating func appendSections(_ sections: [Section]) {
    base.appendSections(sections.map(\.id))
    for section in sections {
      _sections[section.id] = section
    }
  }

  public mutating func insertSections(_ sections: [Section], beforeSection beforeSectionIdentifier: Section.ID) {
    base.insertSections(sections.map(\.id), beforeSection: beforeSectionIdentifier)
    for section in sections {
      _sections[section.id] = section
    }
  }

  public mutating func insertSections(_ sections: [Section], afterSection afterSectionIdentifier: Section.ID) {
    base.insertSections(sections.map(\.id), afterSection: afterSectionIdentifier)
    for section in sections {
      _sections[section.id] = section
    }
  }

  public mutating func deleteSections(_ identifiers: [Section.ID]) {
    base.deleteSections(identifiers)
    for identifier in identifiers {
      _sections[identifier] = nil
    }
  }

  public mutating func moveSection(_ sectionIdentifier: Section.ID, beforeSection beforeSectionIdentifier: Section.ID) {
    base.moveSection(sectionIdentifier, beforeSection: beforeSectionIdentifier)
  }

  public mutating func moveSection(_ sectionIdentifier: Section.ID, afterSection afterSectionIdentifier: Section.ID) {
    base.moveSection(sectionIdentifier, afterSection: afterSectionIdentifier)
  }

  public mutating func reloadSections(_ sections: [Section]) {
    base.reloadSections(sections.map(\.id))
    for section in sections {
      _sections[section.id] = section
    }
  }
}

@available(iOS 15.0, *)
extension DiffableListDataSourceSnapshot {

  public mutating func appendSections<ID: Hashable>(_ sectionIdentifiers: [Section.ID]) where Section == ListSection<ID> {
    base.appendSections(sectionIdentifiers)
    for sectionIdentifier in sectionIdentifiers {
      _sections[sectionIdentifier] = .init(id: sectionIdentifier)
    }
  }

  public mutating func insertSections<ID: Hashable>(_ sectionIdentifiers: [Section.ID], beforeSection beforeSectionIdentifier: Section.ID) where Section == ListSection<ID> {
    base.insertSections(sectionIdentifiers, beforeSection: beforeSectionIdentifier)
    for sectionIdentifier in sectionIdentifiers {
      _sections[sectionIdentifier] = .init(id: sectionIdentifier)
    }
  }

  public mutating func insertSections<ID: Hashable>(_ sectionIdentifiers: [Section.ID], afterSection afterSectionIdentifier: Section.ID) where Section == ListSection<ID> {
    base.insertSections(sectionIdentifiers, afterSection: afterSectionIdentifier)
    for sectionIdentifier in sectionIdentifiers {
      _sections[sectionIdentifier] = .init(id: sectionIdentifier)
    }
  }
}
