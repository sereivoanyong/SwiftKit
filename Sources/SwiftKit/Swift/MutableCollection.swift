//
//  MutableCollection.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension MutableCollection where Element: Equatable {
  
  @discardableResult
  public mutating func replaceFirst(_ element: Element, with newElement: Element) -> Index? {
    guard let index = firstIndex(of: element) else {
      return nil
    }
    self[index] = newElement
    return index
  }
}
