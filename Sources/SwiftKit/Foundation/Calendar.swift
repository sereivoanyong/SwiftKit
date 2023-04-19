//
//  Calendar.swift
//
//  Created by Sereivoan Yong on 8/26/21.
//

#if canImport(Foundation)
import Foundation

extension Calendar {

  @inlinable
  public static func current(locale: Locale? = nil, timeZone: TimeZone? = nil) -> Calendar {
    var calendar = current
    calendar.locale = locale
    if let timeZone {
      calendar.timeZone = timeZone
    }
    return calendar
  }
}
#endif
