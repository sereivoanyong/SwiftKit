//
//  NumberFormatter.swift
//
//  Created by Sereivoan Yong on 6/19/20.
//

#if canImport(Foundation)
import Foundation

extension NumberFormatter {
  
  @inlinable public convenience init(numberStyle: Style, locale: Locale? = nil) {
    self.init()
    self.numberStyle = numberStyle
    self.locale = locale
  }
  
  @inlinable public func string<T>(from number: T) -> String? where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSNumber {
    return string(from: number._bridgeToObjectiveC())
  }
  
  @inlinable public func decimal(from string: String) -> Decimal? {
    assert(generatesDecimalNumbers)
    return number(from: string) as! NSDecimalNumber? as Decimal?
  }
}
#endif
