//
//  Sequence.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension Sequence {
  
  /// Returns an array containing, in order, the first unique elements of the sequence that compare equally for the key path.
  public func firstUnique<T: Hashable>(for keyPath: KeyPath<Element, T>) -> [Element] {
    var unique = Set<T>()
    return filter { unique.insert($0[keyPath: keyPath]).inserted }
  }
  
  @inlinable public func first<T>(where keyPath: KeyPath<Element, T>, equalTo value: T) -> Element? where T: Equatable {
    return first(where: { $0[keyPath: keyPath] == value })
  }
  
  @inlinable public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
    return map { $0[keyPath: keyPath] }
  }
  
  public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
    var count = 0
    for element in self where try predicate(element) {
      count += 1
    }
    return count
  }
  
  public func count<S>(where predicate: (Element) throws -> Bool, next: (Element) throws -> S) rethrows -> Int
    where S: Sequence, S.Element == Element {
      var count = 0
      for element in self {
        if try predicate(element) {
          count += 1
        }
        count += try next(element).count(where: predicate, next: next)
      }
      return count
  }
  
  public func contains<S>(where predicate: (Element) throws -> Bool, next: (Element) throws -> S) rethrows -> Bool
    where S: Sequence, S.Element == Element {
      for element in self {
        if try predicate(element) {
          return true
        }
        if try next(element).contains(where: predicate, next: next) {
          return true
        }
      }
      return false
  }
  
  public func first<T, S>(ofType type: T.Type, next: (Element) throws -> S) rethrows -> T?
    where S: Sequence, S.Element == Element {
      return try first(ofType: T.self, where: { _ in true }, next: next)
  }
  
  public func first<T, S>(ofType type: T.Type, where predicate: (T) throws -> Bool, next: (Element) throws -> S) rethrows -> T?
    where S: Sequence, S.Element == Element {
      for element in self {
        if let target = element as? T, try predicate(target) {
          return target
        } else if let nextTarget = try next(element).first(ofType: T.self, where: predicate, next: next) {
          return nextTarget
        }
      }
      return nil
  }
  
  public func first<S>(where predicate: (Element) throws -> Bool, next: (Element) throws -> S) rethrows -> Element?
    where S: Sequence, S.Element == Element {
      for element in self {
        if try predicate(element) {
          return element
        } else if let nextTarget = try next(element).first(where: predicate, next: next) {
          return nextTarget
        }
      }
      return nil
  }
  
  public func dictionary<Key, Value>(_ transform: (Element) throws -> (Key, Value)?) rethrows -> [Key: Value] where Key: Hashable {
    var dictionary: [Key: Value] = [:]
    for element in self {
      if let (key, value) = try transform(element) {
        dictionary[key] = value
      }
    }
    return dictionary
  }
  
  public func count<Value>(_ initialValue: Value, _ nextPartialValue: (Value, Element) -> Value, while predicate: (Value) -> Bool) -> Int {
    var count: Int = 0
    var value = initialValue
    for element in self {
      if predicate(value) {
        return count
      }
      value = nextPartialValue(value, element)
      count += 1
    }
    return count
  }
  
  public var array: [Element] {
    return [Element](self)
  }
  
  public var contiguousArray: ContiguousArray<Element> {
    return ContiguousArray<Element>(self)
  }
}
