//
//  AnyHashableBox.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/19/26.
//

import Foundation

@available(iOS 13.0, *)
public struct AnyHashableBox<Wrapped>: Sendable {

  @inline(__always)
  public let base: any Hashable & Sendable

  @inline(__always)
  nonisolated(unsafe) public let value: Wrapped

  public init(_ base: some Hashable & Sendable, _ value: Wrapped) {
    self.base = base
    self.value = value
  }

  public init<ID: Hashable & Sendable>(_ value: Wrapped) where Wrapped: Identifiable<ID> {
    self.init(value.id, value)
  }

  @_disfavoredOverload
  public init(_ value: Wrapped) where Wrapped: AnyObject {
    self.init(ObjectIdentifier(value), value)
  }
}

@available(iOS 13.0, *)
extension AnyHashableBox: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return AnyEquatable(lhs.base) == AnyEquatable(rhs.base)
  }
}

@available(iOS 13.0, *)
extension AnyHashableBox: Hashable {

  // https://forums.swift.org/t/use-hashable-hash-into-or-hasher-combine/14325/3
  // https://github.com/swiftlang/swift/blob/c071befc450392debdf0e9db4a20a95e32f43cac/stdlib/public/core/Hasher.swift#L354
  public func hash(into hasher: inout Hasher) {
    base.hash(into: &hasher)
  }
}

@available(iOS 13.0, *)
extension Identifiable where ID: Hashable & Sendable {

  public func idHashable() -> AnyHashableBox<Self> {
    return AnyHashableBox<Self>(id, self)
  }
}
