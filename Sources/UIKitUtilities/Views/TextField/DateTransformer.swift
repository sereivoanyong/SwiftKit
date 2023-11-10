//
//  DateTransformer.swift
//
//  Created by Sereivoan Yong on 6/26/21.
//

#if os(iOS)

import Foundation

/// A transformer that converts between dates and their textual representations
public enum DateTransformer {

  case formatted(DateFormatter)
  case custom(from: (String) -> Date?, to: (Date) -> String)

  public static var `default`: Self {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return .formatted(formatter)
  }

  @inlinable
  public func string(from date: Date) -> String {
    switch self {
    case .formatted(let dateFormatter):
      return dateFormatter.string(from: date)
    case .custom(_, let transformTo):
      return transformTo(date)
    }
  }

  @inlinable
  public func date(from string: String) -> Date? {
    switch self {
    case .formatted(let dateFormatter):
      return dateFormatter.date(from: string)
    case .custom(let transformFrom, _):
      return transformFrom(string)
    }
  }
}

#endif
