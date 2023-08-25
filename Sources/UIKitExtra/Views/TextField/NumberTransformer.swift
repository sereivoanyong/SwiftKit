//
//  NumberTransformer.swift
//
//  Created by Sereivoan Yong on 6/26/21.
//

#if os(iOS)

import Foundation

public enum NumberTransformer<Number: _ObjectiveCBridgeable> where Number._ObjectiveCType: NSNumber {

  case formatted(NumberFormatter)
  case custom((Number) -> String?, (String) -> Number?)

  @inlinable
  public func string(from number: Number) -> String? {
    switch self {
    case .formatted(let formatter):
      return formatter.string(from: number._bridgeToObjectiveC())
    case .custom(let stringFrom, _):
      return stringFrom(number)
    }
  }

  @inlinable
  public func number(from string: String) -> Number? {
    switch self {
    case .formatted(let formatter):
      return formatter.number(from: string) as! Number?
    case .custom(_, let numberFrom):
      return numberFrom(string)
    }
  }
}

extension NumberTransformer where Number: LosslessStringConvertible {

  public static var `default`: Self {
    return .custom({ $0.description }, { Number.init($0) })
  }
}

#endif
