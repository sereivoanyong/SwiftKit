//
//  DateFormatter.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(Foundation)
import Foundation

extension DateFormatter {
  
  @inlinable public convenience init(dateStyle: Style, timeStyle: Style, locale: Locale? = nil, timeZone: TimeZone? = nil, calendar: Calendar? = nil) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
    self.locale = locale
    self.timeZone = timeZone
    self.calendar = calendar
  }
  
  @inlinable public convenience init(dateFormat: String, locale: Locale? = nil, timeZone: TimeZone? = nil, calendar: Calendar? = nil) {
    self.init()
    self.dateFormat = dateFormat
    self.locale = locale
    self.timeZone = timeZone
    self.calendar = calendar
  }
  
  @inlinable public convenience init?(localizedDateFormatFromTemplate template: String, locale: Locale? = nil, timeZone: TimeZone? = nil, calendar: Calendar? = nil) {
    if let localizedDateFormat = Self.dateFormat(fromTemplate: template, options: 0, locale: locale) {
      self.init(dateFormat: localizedDateFormat, locale: locale, timeZone: timeZone, calendar: calendar)
    } else {
      return nil
    }
  }
  
  public static func iso8601(withFractionalSeconds: Bool) -> DateFormatter {
    let dateFormat = withFractionalSeconds ? "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" : "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return DateFormatter(dateFormat: dateFormat, locale: Locale(identifier: "en_US_POSIX"), timeZone: TimeZone(secondsFromGMT: 0), calendar: Calendar(identifier: .iso8601))
  }
}
#endif
