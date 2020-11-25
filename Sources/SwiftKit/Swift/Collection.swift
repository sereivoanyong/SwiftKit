//
//  Collection.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension Collection {
  
  @inlinable public var nonEmpty: Self? {
    return isEmpty ? nil : self
  }
  
  @inlinable public subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
  
  public subscript<S: Sequence>(indexes indexes: S) -> [Element] where S.Element == Index {
    return indexes.map { self[$0] }
  }
  
  public func indices(where predicate: (Element) throws -> Bool) rethrows -> [Index] {
    var indices: [Index] = []
    indices.reserveCapacity(count)
    var index = startIndex
    while index < endIndex {
      if try predicate(self[index]) {
        indices.append(index)
      }
      formIndex(after: &index)
    }
    return indices
  }
  
  public func indices(of element: Element) -> [Index] where Element: Equatable {
    return indices(where: { $0 == element })
  }
  
  public func randomElement<S>(excluding excludingElements: S) -> Element? where S: Collection, S.Element: Equatable, S.Element == Element {
    guard var targetElement = randomElement() else {
      return nil
    }
    while excludingElements.contains(targetElement) {
      targetElement = randomElement()!
    }
    return targetElement
  }
  
  public func grouping<Key>(by keyForValue: (Element) -> Key) -> [(Key, [Element])] where Key: Hashable {
    var orders: [Key: Int] = [:]
    var groups: [Key: [Element]] = [:]
    for (index, value) in enumerated() {
      let key = keyForValue(value)
      if orders[key] == nil {
        orders[key] = index
      }
      groups[key, default: []].append(value)
    }
    return groups.sorted(by: { orders[$0.key]! < orders[$1.key]! })
  }
}
