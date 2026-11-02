//
//  HashableBox.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/19/26.
//

public struct HashableBox<Base>: Sendable {

  nonisolated(unsafe) public let base: Base

  @usableFromInline
  nonisolated(unsafe) let id: AnyHashable

  @inlinable
  public init(_ base: Base, _ id: some Hashable & Sendable) {
    self.base = base
    self.id = id
  }

  @inlinable
  public init(_ base: Base) where Base: Identifiable {
    self.base = base
    self.id = base.id
  }

  @_disfavoredOverload
  @inlinable
  public init(_ base: Base) where Base: AnyObject {
    self.base = base
    self.id = ObjectIdentifier(base)
  }
}

extension HashableBox: Equatable {

  @inlinable
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}

extension HashableBox: Hashable {

  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Identifiable where ID: Hashable & Sendable {

  public func hashableBoxed() -> HashableBox<Self> {
    return HashableBox<Self>(self, id)
  }
}
