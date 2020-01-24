//
//  AnyEquatable.swift
//
//  Created by Sereivoan Yong on 10/29/17.
//

public struct AnyEquatable {
  
  public let value: Any
  private let equals: (AnyEquatable) -> Bool
  
  public init<E>(_ base: E) where E: Equatable {
    self.value = base
    equals = {
      if let otherValue = $0.value as? E {
        return otherValue == base
      }
      return false
    }
  }
}

extension AnyEquatable: Equatable {
  
  public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
    return lhs.equals(rhs) || rhs.equals(lhs)
  }
}

extension AnyEquatable: CustomStringConvertible {
  
  public var description: String {
    return String(describing: value)
  }
}

extension AnyEquatable: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    return "AnyEquatable(" + String(reflecting: value) + ")"
  }
}

extension AnyEquatable: CustomReflectable {
  
  public var customMirror: Mirror {
    return Mirror(self, children: ["value": value])
  }
}
