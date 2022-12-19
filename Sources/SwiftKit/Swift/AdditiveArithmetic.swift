//
//  AdditiveArithmetic.swift
//
//  Created by Sereivoan Yong on 12/16/22.
//

import Foundation

extension Optional where Wrapped: AdditiveArithmetic {

  public var isNilOrZero: Bool {
    switch self {
    case .none:
      return true
    case .some(let number):
      return number == .zero
    }
  }

  public var nonZero: Wrapped? {
    switch self {
    case .none:
      return nil
    case .some(let number):
      return number == .zero ? nil : number
    }
  }
}
