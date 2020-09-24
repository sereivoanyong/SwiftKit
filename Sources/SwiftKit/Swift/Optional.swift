//
//  Optional.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

extension Optional {
  
  public func unwrapped(or error: Error) throws -> Wrapped {
    switch self {
    case .some(let wrapped):
      return wrapped
    case .none:
      throw error
    }
  }
  
  public func isSameSomeOrNoneAs(_ value: Optional<Wrapped>) -> Bool {
    switch (self, value) {
    case (.some, .some):
      return true
    case (.none, .none):
      return true
    default:
      return false
    }
  }
  
  public func `do`(_ bodyWhenNonnil: (Wrapped) -> Void, _ bodyWhenNil: () -> Void) {
    switch self {
    case .some(let wrapped):
      bodyWhenNonnil(wrapped)
    case .none:
      bodyWhenNil()
    }
  }
  
  public mutating func append(_ newElement: Wrapped.Element, default: @autoclosure () -> Wrapped) where Wrapped: RangeReplaceableCollection {
    var collection = self ?? `default`()
    collection.append(newElement)
    self = collection
  }
  
  public mutating func insert(_ newElement: Wrapped.Element, at index: Int, default: @autoclosure () -> Wrapped) where Wrapped: RangeReplaceableCollection, Wrapped.Index == Int {
    var collection = self ?? `default`()
    collection.insert(newElement, at: index)
    self = collection
  }
}

extension Optional where Wrapped: Collection {
  
  public var isNilOrEmpty: Bool {
    switch self {
    case .none:
      return true
    case .some(let collection):
      return collection.isEmpty
    }
  }
  
  /// Returns nil if the collection is nil or empty.
  public var nonEmpty: Wrapped? {
    switch self {
    case .none:
      return .none
    case .some(let collection):
      return collection.isEmpty ? .none : .some(collection)
    }
  }
}
