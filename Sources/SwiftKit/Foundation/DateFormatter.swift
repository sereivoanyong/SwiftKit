//
//  DateFormatter.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(Foundation)
import Foundation

extension DateFormatter {
  
  @inlinable public convenience init(dateStyle: Style, timeStyle: Style) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }
  
  @inlinable public convenience init(dateFormat: String) {
    self.init()
    self.dateFormat = dateFormat
  }
  
  public static func iso8601(withFractionalSeconds: Bool) -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = withFractionalSeconds ? "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" : "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
  }
}
#endif
