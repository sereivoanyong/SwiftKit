//
//  MarkFormatter.swift
//
//  Created by Sereivoan Yong on 2/5/24.
//

#if canImport(Foundation)

import Foundation

extension MarkFormatter {

  public enum SurroundingMark {

    case parenthesis
    case quotation
    case singleQuotation
  }

  public enum JoiningMark {

    case colon
  }
}

/// See: https://ltl-shanghai.com/chinese-punctuation/
final public class MarkFormatter {

  public let surroundingMarkFormatForLanguageCode: [String: [SurroundingMark: String]] = [
    "zh": [
      .parenthesis: "（%@）",
      .quotation: "“%@“",
      .singleQuotation: "‘%@‘"
    ]
  ]

  public let joiningMarkFormatForLanguageCode: [String: [JoiningMark: String]] = [
    "zh": [
      .colon: "%@：%@"
    ]
  ]

  public var locale: Locale

  public init(locale: Locale = .current) {
    self.locale = locale
  }

  public func localized(_ string: String, _ mark: SurroundingMark) -> String {
    let format: String
    if let languageCode = locale.languageCode, let knownFormat = surroundingMarkFormatForLanguageCode[languageCode]?[mark] {
      format = knownFormat
    } else {
      switch mark {
      case .parenthesis:
        format = "(\(string))"
      case .quotation:
        format = "”\(string)”"
      case .singleQuotation:
        format = "’\(string)’"
      }
    }
    return String(format: format, string)
  }

  public func localized(_ string: String, _ string2: String, _ mark: JoiningMark) -> String {
    let format: String
    if let languageCode = locale.languageCode, let knownFormat = joiningMarkFormatForLanguageCode[languageCode]?[mark] {
      format = knownFormat
    } else {
      format = "%@: %@"
    }
    return String(format: format, string, string2)
  }

  public func joinLocalized(_ strings: String...) -> String {
    guard strings.count > 1 else {
      return strings.first ?? ""
    }
    let format: String
    switch locale.languageCode {
    case "zh":
      format = "%@%@"
    default:
      format = "%@ %@"
    }
    var strings = strings
    var iterator = strings.makeIterator()
    var result = iterator.next()!
    while let string = iterator.next() {
      result = String(format: format, result, string)
    }
    return result
  }
}

#endif
