//
//  NumberFormatter.swift
//
//  Created by Sereivoan Yong on 6/19/20.
//

#if canImport(Foundation)
import Foundation

extension NumberFormatter {

  @inlinable
  public convenience init(numberStyle: Style, locale: Locale? = nil) {
    self.init()
    self.numberStyle = numberStyle
    self.locale = locale
  }

  @inlinable
  final public func string<T: _ObjectiveCBridgeable>(from number: T) -> String? where T._ObjectiveCType: NSNumber {
    string(from: number._bridgeToObjectiveC())
  }

  @inlinable
  final public func decimal(from string: String) -> Decimal? {
    assert(generatesDecimalNumbers)
    return number(from: string) as! NSDecimalNumber? as Decimal?
  }
}
#endif
