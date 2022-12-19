//
//  Optional.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation
#endif

extension Optional {
  
  public func unwrapped(or error: Error) throws -> Wrapped {
    switch self {
    case .none:
      throw error
    case .some(let wrapped):
      return wrapped
    }
  }
  
  public func isSameSomeOrNoneAs(_ value: Optional<Wrapped>) -> Bool {
    switch (self, value) {
    case (.none, .none):
      return true
    case (.some, .some):
      return true
    default:
      return false
    }
  }
  
  public func `do`(_ bodyWhenNonnil: (Wrapped) -> Void, _ bodyWhenNil: () -> Void) {
    switch self {
    case .none:
      bodyWhenNil()
    case .some(let wrapped):
      bodyWhenNonnil(wrapped)
    }
  }

  public mutating func modify(default defaultValue: @autoclosure () -> Wrapped, _ modify: (inout Wrapped) -> Void) {
    switch self {
    case .none:
      var wrapped = defaultValue()
      modify(&wrapped)
      self = wrapped
    case .some:
      modify(&self!)
    }
  }

  public mutating func modifying(default defaultValue: @autoclosure () -> Wrapped, _ modify: (inout Wrapped) -> Void) -> Wrapped {
    switch self {
    case .none:
      var wrapped = defaultValue()
      modify(&wrapped)
      return wrapped
    case .some(let wrapped):
      var wrapped = _copy(wrapped)
      modify(&wrapped)
      return wrapped
    }
  }
}
