//
//  Decimal.swift
//
//  Created by Sereivoan Yong on 11/27/20.
//

#if canImport(Foundation)
import Foundation

extension Decimal {
  
  /// Compacts the decimal structure for efficiency.
  ///
  /// Formats number so that calculations using it will take up as little memory as possible. All the `NSDecimal`... arithmetic functions expect compact `Decimal` arguments.
  public mutating func compact() {
    NSDecimalCompact(&self)
  }
  
  /// Returns the compacts decimal structure for efficiency.
  ///
  /// Formats number so that calculations using it will take up as little memory as possible. All the `NSDecimal`... arithmetic functions expect compact `Decimal` arguments.
  public func compacted() -> Decimal {
    var result = self
    result.compact()
    return result
  }
  
  /// Rounds off the decimal value
  ///
  /// - Parameters:
  ///   - scale: specifies the number of digits result can have after its decimal point.
  ///   - mode: specifies the way that number is rounded off. There are four possible values for `mode`: `.down`, `.up`, `.plain`, and `.bankers`.
  public mutating func round(scale: Int, mode: RoundingMode) {
    var decimal = self
    NSDecimalRound(&self, &decimal, scale, mode)
  }
  
  /// Returns the rounded-off decimal value
  ///
  /// - Parameters:
  ///   - scale: specifies the number of digits result can have after its decimal point.
  ///   - mode: specifies the way that number is rounded off. There are four possible values for `mode`: `.down`, `.up`, `.plain`, and `.bankers`.
  public func rounded(scale: Int, mode: RoundingMode) -> Decimal {
    var result = self
    result.round(scale: scale, mode: mode)
    return result
  }
}
#endif
