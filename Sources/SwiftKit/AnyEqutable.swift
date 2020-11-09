//
//  AnyEquatable.swift
//
//  Created by Sereivoan Yong on 10/29/17.
//

// See https://github.com/apple/swift/blob/main/stdlib/public/core/AnyHashable.swift

@usableFromInline
internal protocol _AnyEquatableBox {
  
  var _base: Any { get }
  func _unbox<T: Equatable>() -> T?
  
  /// Determine whether values in the boxes are equivalent.
  ///
  /// - Precondition: `self` and `box` are in canonical form.
  /// - Returns: `nil` to indicate that the boxes store different types, so
  ///   no comparison is possible. Otherwise, contains the result of `==`.
  func _isEqual(to box: _AnyEquatableBox) -> Bool?
}

internal struct _ConcreteEquatableBox<Base: Equatable>: _AnyEquatableBox {
  
  internal let _baseEquatable: Base
  
  internal init(_ base: Base) {
    self._baseEquatable = base
  }
  
  internal var _base: Any {
    return _baseEquatable
  }
  
  internal func _unbox<T: Equatable>() -> T? {
    return (self as _AnyEquatableBox as? _ConcreteEquatableBox<T>)?._baseEquatable
  }
  
  internal func _isEqual(to rhs: _AnyEquatableBox) -> Bool? {
    if let rhs: Base = rhs._unbox() {
      return _baseEquatable == rhs
    }
    return nil
  }
}

/// A type-erased equatable value.
///
/// The `AnyEquatable` type forwards equality comparisons to an underlying equatable
/// value, hiding the type of the wrapped value.
///
/// Where conversion using `as` or `as?` is possible between two types (such as
/// `Int` and `NSNumber`), `AnyEquatable` uses a canonical representation of the
/// type-erased value so that instances wrapping the same value of either type
/// compare as equal. For example, `AnyEquatable(42)` compares as equal to
/// `AnyEquatable(42 as NSNumber)`.
public struct AnyEquatable {
  
  internal let _box: _AnyEquatableBox
  
  /// Creates a type-erased equatable value that wraps the given instance.
  ///
  /// - Parameter base: An equatable value to wrap.
  public init<E: Equatable>(_ base: E) {
    _box = _ConcreteEquatableBox(base)
  }
  
  /// The value wrapped by this instance.
  ///
  /// The `base` property can be cast back to its original type using one of
  /// the type casting operators (`as?`, `as!`, or `as`).
  ///
  ///     let anyMessage = AnyEquatable("Hello world!")
  ///     if let unwrappedMessage = anyMessage.base as? String {
  ///         print(unwrappedMessage)
  ///     }
  ///     // Prints "Hello world!"
  public var base: Any {
    return _box._base
  }
}

extension AnyEquatable: Equatable {
  
  public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
    return lhs._box._isEqual(to: rhs._box) ?? false
  }
}

extension AnyEquatable: CustomStringConvertible {
  
  public var description: String {
    return String(describing: base)
  }
}

extension AnyEquatable: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    return "AnyEquatable(" + String(reflecting: base) + ")"
  }
}

extension AnyEquatable: CustomReflectable {
  
  public var customMirror: Mirror {
    return Mirror(self, children: ["value": base])
  }
}
