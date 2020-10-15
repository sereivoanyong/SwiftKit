//
//  MeasurementFormatter.swift
//
//  Created by Sereivoan Yong on 10/15/20.
//

#if canImport(Foundation)
import Foundation

@available(iOS 10.0, *)
extension MeasurementFormatter {
  
  @inlinable public convenience init(unitOptions: UnitOptions, unitStyle: UnitStyle = .medium, locale: Locale? = nil) {
    self.init()
    self.unitOptions = unitOptions
    self.unitStyle = unitStyle
    self.locale = locale
  }
}
#endif
