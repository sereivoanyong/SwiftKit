//
//  IndexSet.swift
//
//  Created by Sereivoan Yong on 11/26/20.
//

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
