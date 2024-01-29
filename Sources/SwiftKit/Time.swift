//
//  Time.swift
//
//  Created by Sereivoan Yong on 1/29/24.
//

#if canImport(Foundation)

import Foundation

public struct Time {

  public static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter
  }()

  public let string: String
  public let timeIntervalSinceStartOfDay: TimeInterval

  public init?(string: String?) {
    guard let string, let date = Self.formatter.date(from: string) else {
      return nil
    }
    self.string = string
    self.timeIntervalSinceStartOfDay = date.timeIntervalSinceReferenceDate - Self.formatter.calendar.startOfDay(for: date).timeIntervalSinceReferenceDate
  }

  public init(date: Date) {
    self.string = Self.formatter.string(from: date)
    self.timeIntervalSinceStartOfDay = date.timeIntervalSinceReferenceDate - Self.formatter.calendar.startOfDay(for: date).timeIntervalSinceReferenceDate
  }
}

extension Time: Equatable {

  public static func == (lhs: Time, rhs: Time) -> Bool {
    return lhs.timeIntervalSinceStartOfDay == rhs.timeIntervalSinceStartOfDay
  }
}

extension Time: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(timeIntervalSinceStartOfDay)
  }
}

extension Time: Comparable {

  public static func < (lhs: Time, rhs: Time) -> Bool {
    return lhs.timeIntervalSinceStartOfDay < rhs.timeIntervalSinceStartOfDay
  }
}

extension Time: CustomStringConvertible {

  public var description: String {
    return string
  }
}

extension Time: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    guard let time = Self(string: string) else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid time string (valid format is \(Time.formatter.dateFormat!))"))
    }
    self = time
  }
}

extension Time: Encodable {

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(string)
  }
}

extension Date {

  public var time: Time {
    return Time(date: self)
  }
}

#endif
