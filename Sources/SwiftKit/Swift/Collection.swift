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
}
