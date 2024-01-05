//
//  Sequence.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension Sequence {

  /// Returns the number of elements of the sequence that satisfy the given `predicate`.
  public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
    var count = 0
    for element in self where try predicate(element) {
      count += 1
    }
    return count
  }

  public func count<T: Equatable>(where transform: (Element) throws -> T, equalTo value: T) rethrows -> Int {
    return try count { try transform($0) == value }
  }

  public func filter<T: Equatable>(where transform: (Element) throws -> T, equalTo value: T) rethrows -> [Element] {
    return try filter { try transform($0) == value }
  }

  public func first<T: Equatable>(where transform: (Element) throws -> T, equalTo value: T) rethrows -> Element? {
    return try first { try transform($0) == value }
  }

  /// Returns an array containing, in order, the first unique elements of the sequence that compare equally for the key path.
  public func firstUnique<T: Hashable>(where transform: (Element) throws -> T) rethrows -> [Element] {
    var unique: Set<T> = []
    return try filter { unique.insert(try transform($0)).inserted }
  }

  /// Returns the first element of the `type` of the sequence that satisfies the given `predicate`.
  ///
  ///     let view = UIView()
  ///     if let textField = first(of: UITextField.self, where: { $0.hasText }) {
  ///         print("The first non-empty text field is \(textField).")
  ///     }
  public func first<T>(of type: T.Type, where predicate: (T) throws -> Bool = { _ in true }) rethrows -> T? {
    for element in self {
      if let match = element as? T, try predicate(match) {
        return match
      }
    }
    return nil
  }

  /// Returns the first element of the `type` of the sequence that satisfies the given `predicate` or first descendant that does.
  ///
  ///     let view = UIView()
  ///     if let textField = first(of: UITextField.self, where: { $0.hasText }, descendants: \.subviews) {
  ///         print("The first non-empty descendant text field is \(textField).")
  ///     }
  public func first<T>(of type: T.Type, where predicate: (T) throws -> Bool = { _ in true }, descendants: (Element) -> some Sequence<Element>) rethrows -> T? {
    if let first = try first(of: type, where: predicate) {
      return first
    }
    for element in self {
      if let first = try descendants(element).first(of: T.self, where: predicate, descendants: descendants) {
        return first
      }
    }
    return nil
  }
  
  public func dictionary<Key: Hashable, Value>(_ transform: (Element) throws -> (Key, Value)?) rethrows -> [Key: Value] {
    var dictionary: [Key: Value] = [:]
    for element in self {
      if let (key, value) = try transform(element) {
        dictionary[key] = value
      }
    }
    return dictionary
  }
  
  public var array: [Element] {
    return [Element](self)
  }
  
  public var contiguousArray: ContiguousArray<Element> {
    return ContiguousArray<Element>(self)
  }
}

extension Sequence where Element: Hashable {

  public var set: Set<Element> {
    return Set<Element>(self)
  }
}
