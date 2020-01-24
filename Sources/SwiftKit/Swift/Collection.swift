//
//  Collection.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension Collection {
  
  @inlinable public subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
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
}

extension Collection where Element: Equatable {
  
  public func randomElement<S>(excluding excludingElements: S) -> Element? where S: Collection, S.Element == Element {
    guard var targetElement = randomElement() else {
      return nil
    }
    while excludingElements.contains(targetElement) {
      targetElement = randomElement()!
    }
    return targetElement
  }
  
  public func indices(of element: Element) -> [Index] {
    return indices(where: { $0 == element })
  }
}
