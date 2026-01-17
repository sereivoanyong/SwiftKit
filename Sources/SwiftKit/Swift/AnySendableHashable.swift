//
//  AnySendableHashable.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/17/26.
//

/// A type-erased hashable, sendable value.
///
/// A sendable version of `AnyHashable` that is useful in working around the limitation that an
/// existential `any Hashable` does not conform to `Hashable`.
public struct AnySendableHashable: Hashable, Sendable {

  public let base: any Hashable & Sendable

  /// Creates a type-erased hashable, sendable value that wraps the given instance.
  public init(_ base: some Hashable & Sendable) {
    if let base = base as? AnySendableHashable {
      self = base
    } else {
      self.base = base
    }
  }

  /// Creates a type-erased hashable, sendable value that wraps the given instance.
  @_disfavoredOverload
  public init(_ base: any Hashable & Sendable) {
    self.init(base)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    AnyHashable(lhs.base) == AnyHashable(rhs.base)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(base)
  }
}

extension AnySendableHashable: CustomStringConvertible {

  public var description: String {
    return String(describing: base)
  }
}

extension AnySendableHashable: CustomDebugStringConvertible {

  public var debugDescription: String {
    return "AnySendableHashable(" + String(reflecting: base) + ")"
  }
}

extension AnySendableHashable: CustomReflectable {

  public var customMirror: Mirror {
    return Mirror(self, children: ["value": base])
  }
}

extension AnySendableHashable: _HasCustomAnyHashableRepresentation {

  public func _toCustomAnyHashable() -> AnyHashable? {
    base as? AnyHashable
  }
}
