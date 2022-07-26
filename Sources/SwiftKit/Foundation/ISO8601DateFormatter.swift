//
//  ISO8601DateFormatter.swift
//
//  Created by Sereivoan Yong on 12/23/21.
//

#if canImport(Foundation)
import Foundation

@available(iOS 10.0, *)
extension ISO8601DateFormatter {

  @inlinable
  public convenience init(timeZone: TimeZone? = nil, formatOptions: Options) {
    self.init()
    self.timeZone = timeZone
    self.formatOptions = formatOptions
  }
}

extension Date {

  @available(iOS 10.0, *)
  @inlinable
  public func formatted(by formatter: ISO8601DateFormatter) -> String {
    return formatter.string(from: self)
  }
}
#endif
