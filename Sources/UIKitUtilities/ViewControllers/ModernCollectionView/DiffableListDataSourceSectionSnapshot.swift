//
//  DiffableListDataSourceSectionSnapshot.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/25/25.
//

import UIKit

@available(iOS 15.0, *)
public struct DiffableListDataSourceSectionSnapshot<Item: Identifiable> {

  @usableFromInline
  var base: NSDiffableDataSourceSectionSnapshot<Item.ID>

  @usableFromInline
  var _items: [Item.ID: Item]

  public var items: [Item] {
    return itemIdentifiers.map { _items[$0]! }
  }

  public var itemIdentifiers: [Item.ID] {
    return base.items
  }

  init(base: NSDiffableDataSourceSectionSnapshot<Item.ID>, items: [Item.ID: Item]) {
    assert(base.items.count == items.count)
    self.base = base
    self._items = items
  }

  public init() {
    base = .init()
    _items = [:]
  }

  @inlinable
  public func itemIdentifier(at index: Int) -> Item.ID {
    return base.items[index]
  }

  @inlinable
  public func item(at index: Int) -> Item {
    return _items[itemIdentifier(at: index)]!
  }

  @inlinable
  public mutating func append(_ items: [Item]) {
    base.append(items.map(\.id))
    for item in items {
      _items[item.id] = item
    }
  }

  @inlinable
  public mutating func insert(_ items: [Item], before beforeItemIdentifier: Item.ID) {
    base.insert(items.map(\.id), before: beforeItemIdentifier)
    for item in items {
      _items[item.id] = item
    }
  }

  @inlinable
  public mutating func insert(_ items: [Item], after afterItemIdentifier: Item.ID) {
    base.insert(items.map(\.id), after: afterItemIdentifier)
    for item in items {
      _items[item.id] = item
    }
  }

  @inlinable
  public mutating func delete(_ itemIdentifiers: [Item.ID]) {
    base.delete(itemIdentifiers)
    for itemIdentifier in itemIdentifiers {
      _items[itemIdentifier] = nil
    }
  }

  @inlinable
  public mutating func deleteAll() {
    base.deleteAll()
    _items.removeAll()
  }
}
