//
//  RangeReplaceableCollection.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension RangeReplaceableCollection {
  
  public static func += (lhs: inout Self, rhs: Element) {
    lhs.append(rhs)
  }
  
  public mutating func replaceAll<S>(with objects: S, keepsCapacity: Bool = false) where S: Sequence, S.Element == Element {
    removeAll(keepingCapacity: keepsCapacity)
    self += objects
  }
}

extension RangeReplaceableCollection where Element: Equatable {
  
  @discardableResult
  public mutating func removeFirst(_ element: Element) -> Index? {
    guard let index = firstIndex(of: element) else {
      return nil
    }
    remove(at: index)
    return index
  }
}

extension RangeReplaceableCollection where Index == Int {
  
  /// insert at last 0 is equivalant to `append` or `insert(_:at:count-1)`
  @inlinable public mutating func insert(_ newElement: Element, atLast k: Index) {
    precondition(k <= 0)
    insert(newElement, at: count + k)
  }
}

#if canImport(Foundation)
import Foundation

extension RangeReplaceableCollection where Index == IndexSet.Element {
  
  public subscript(indexSet: IndexSet) -> [Element] {
    var collection: [Element] = []
    for index in indexSet {
      collection.append(self[index])
    }
    return collection
  }
  
  @discardableResult
  public mutating func remove(at indexSet: IndexSet) -> [Element] {
    var removedElements: [Element] = []
    for index in indexSet.reversed() {
      removedElements.append(remove(at: index))
    }
    return removedElements
  }
}
#endif
