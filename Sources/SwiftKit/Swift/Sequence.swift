//
//  Sequence.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension Sequence {

  @inlinable public func filter<T>(where keyPath: KeyPath<Element, T>, equalTo value: T) -> [Element] where T: Equatable {
    return filter({ $0[keyPath: keyPath] == value })
  }

  @inlinable public func first<T>(where keyPath: KeyPath<Element, T>, equalTo value: T) -> Element? where T: Equatable {
    return first(where: { $0[keyPath: keyPath] == value })
  }

  /// Returns an array containing, in order, the first unique elements of the sequence that compare equally for the key path.
  public func firstUnique<T: Hashable>(for keyPath: KeyPath<Element, T>) -> [Element] {
    var unique = Set<T>()
    return filter { unique.insert($0[keyPath: keyPath]).inserted }
  }

  @inlinable
  public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
    map { $0[keyPath: keyPath] }
  }

  @inlinable
  public func flatMap<SegmentOfResult>(_ keyPath: KeyPath<Element, SegmentOfResult>) -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
    flatMap { $0[keyPath: keyPath] }
  }

  @inlinable
  public func compactMap<ElementOfResult>(_ keyPath: KeyPath<Element, ElementOfResult?>) -> [ElementOfResult] {
    compactMap { $0[keyPath: keyPath] }
  }

  /// Returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate or a descendant that does.
  public func contains<S>(where predicate: (Element) throws -> Bool, descendantsProvider: ((Element) -> S?)?) rethrows -> Bool where S: Sequence, S.Element == Element {
    if try contains(where: predicate) {
      return true
    }
    guard let descendantsProvider = descendantsProvider else {
      return false
    }
    for element in self {
      if let descendants = descendantsProvider(element), try descendants.contains(where: predicate, descendantsProvider: descendantsProvider) {
        return true
      }
    }
    return false
  }

  /// Returns the number of elements of the sequence that satisfy the given `predicate`.
  public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
    var count = 0
    for element in self where try predicate(element) {
      count += 1
    }
    return count
  }

  /// Returns the number of elements of the sequence that satisfy the given `predicate` and their descendants that do.
  public func count<S>(where predicate: (Element) throws -> Bool, descendantsProvider: ((Element) -> S?)?) rethrows -> Int where S: Sequence, S.Element == Element {
    guard let descendantsProvider = descendantsProvider else {
      return try count(where: predicate)
    }
    var count = 0
    for element in self {
      if try predicate(element) {
        count += 1
      }
      if let descendants = descendantsProvider(element) {
        count += try descendants.count(where: predicate, descendantsProvider: descendantsProvider)
      }
    }
    return count
  }

  /// Returns the first element of the `type` of the sequence that satisfies the given `predicate`.
  ///
  ///     let view = UIView()
  ///     if let textField = first(of: UITextField.self, where: { $0.hasText }) {
  ///         print("The first non-empty text field is \(textField).")
  ///     }
  public func first<T>(of type: T.Type, where predicate: ((T) throws -> Bool)? = nil) rethrows -> T? {
    for element in self {
      if let match = element as? T, try predicate?(match) ?? true {
        return match
      }
    }
    return nil
  }

  /// Returns the first element of the `type` of the sequence that satisfies the given `predicate` or first descendant that does.
  ///
  ///     let view = UIView()
  ///     if let textField = first(of: UITextField.self, where: { $0.hasText }, descendantsProvider: { $0.subviews }) {
  ///         print("The first non-empty descendant text field is \(textField).")
  ///     }
  public func first<T, S>(of type: T.Type, where predicate: ((T) throws -> Bool)? = nil, descendantsProvider: ((Element) -> S?)?) rethrows -> T? where S: Sequence, S.Element == Element {
    if let first = try first(of: type, where: predicate) {
      return first
    }
    guard let descendantsProvider = descendantsProvider else {
      return nil
    }
    for element in self {
      if let descendants = descendantsProvider(element), let descendantMatch = try descendants.first(of: T.self, where: predicate, descendantsProvider: descendantsProvider) {
        return descendantMatch
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
