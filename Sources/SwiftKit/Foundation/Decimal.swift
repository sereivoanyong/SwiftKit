//
//  Decimal.swift
//
//  Created by Sereivoan Yong on 11/27/20.
//

import Foundation

extension Decimal {

  @inlinable
  public var doubleValue: Double {
    return (self as NSDecimalNumber).doubleValue
  }

  /// Compacts the decimal structure for efficiency.
  ///
  /// Formats number so that calculations using it will take up as little memory as possible. All the `NSDecimal`... arithmetic functions expect compact `Decimal` arguments.
  public mutating func compact() {
    NSDecimalCompact(&self)
  }
  
  /// Returns the compacted decimal structure for efficiency.
  ///
  /// Formats number so that calculations using it will take up as little memory as possible. All the `NSDecimal`... arithmetic functions expect compact `Decimal` arguments.
  public func compacted() -> Decimal {
    var result = self
    result.compact()
    return result
  }
  
  /// Rounds off the decimal value.
  ///
  /// - Parameters:
  ///   - scale: specifies the number of digits result can have after its decimal point.
  ///   - roundingMode: specifies the way that number is rounded off. There are 4 possible values for `roundingMode`: `.down`, `.up`, `.plain`, and `.bankers`.
  public mutating func round(_ scale: Int = 0, _ roundingMode: RoundingMode = .plain) {
    var decimal = self
    NSDecimalRound(&self, &decimal, scale, roundingMode)
  }
  
  /// Returns the rounded-off decimal value.
  ///
  /// - Parameters:
  ///   - scale: specifies the number of digits result can have after its decimal point.
  ///   - roundingMode: specifies the way that number is rounded off. There are 4 possible values for `roundingMode`: `.down`, `.up`, `.plain`, and `.bankers`.
  public func rounded(_ scale: Int = 0, _ roundingMode: RoundingMode = .plain) -> Decimal {
    var result = self
    result.round(scale, roundingMode)
    return result
  }
}
