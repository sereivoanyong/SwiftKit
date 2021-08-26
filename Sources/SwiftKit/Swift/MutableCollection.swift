//
//  MutableCollection.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension MutableCollection {
  
  @discardableResult
  public mutating func replaceFirst(_ element: Element, with newElement: Element) -> Index? where Element: Equatable {
    guard let index = firstIndex(of: element) else {
      return nil
    }
    self[index] = newElement
    return index
  }

  /// Calls the given closure on each element in the collection in the same order as a `for-in` loop.
  ///
  /// The `modifyEach` method provides a mechanism for modifying all of the contained elements in a `MutableCollection`. It differs
  /// from `forEach` or `for-in` by providing the contained elements as `inout` parameters to the closure `body`. In some cases this
  /// will allow the parameters to be modified in-place in the collection, without needing to copy them or allocate a new collection.
  ///
  /// - parameters:
  ///    - body: A closure that takes each element of the sequence as an `inout` parameter
  @inlinable
  public mutating func modifyEach(_ body: (inout Element) throws -> Void) rethrows {
    // See: https://forums.swift.org/t/idea-mutatingforeach-for-collections/18442/20
    var index = startIndex
    while index != endIndex {
      try body(&self[index])
      formIndex(after: &index)
    }
  }
}
