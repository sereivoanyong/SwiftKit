//
//  String.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import Foundation

extension StringProtocol {

  public var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  public var isBlank: Bool {
    return trimmed.isEmpty
  }

  public func strippingCharacters(in characterSet: CharacterSet) -> String {
    return components(separatedBy: characterSet.inverted).joined()
  }

  public func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = [], locale: Locale? = nil) -> [Int] {
    return ranges(of: string, options: options, locale: locale).map { distance(from: startIndex, to: $0.lowerBound) }
  }

  public func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
    var ranges: [Range<Index>] = []
    var position = startIndex
    while let range = range(of: string, options: options, range: position..<endIndex, locale: locale) {
      ranges.append(range)
      position = range.upperBound
    }
    return ranges
  }

  public func removingOccurrences<S: StringProtocol>(of target: S) -> String {
    var result = ""
    result.reserveCapacity(count)
    var remainder = self[...]
    while let range = remainder._firstRange(of: target) {
      result.append(contentsOf: remainder[remainder.startIndex..<range.lowerBound])
      remainder = remainder[range.upperBound...]
    }
    result.append(contentsOf: remainder)
    return result
  }

  public func removingFirstOccurrence<S: StringProtocol>(of target: S) -> String {
    if let range = _firstRange(of: target) {
      var result = ""
      result.reserveCapacity(count - target.count)
      result.append(contentsOf: self[startIndex..<range.lowerBound])
      result.append(contentsOf: self[range.upperBound...])
      return result
    }
    return String(self)
  }

  /// For Emoji Encoded, use `encoded(to: .utf8, from: .nonLossyASCII, allowLossyConversion: true)`
  /// For Emoji Decoded, use `encoded(to: .nonLossyASCII, from: .utf8, allowLossyConversion: true)`
  public func encoded(to toEncoding: String.Encoding, from fromEncoding: String.Encoding, allowLossyConversion: Bool = true) -> String? {
    return data(using: fromEncoding, allowLossyConversion: allowLossyConversion).flatMap { String(data: $0, encoding: toEncoding) }
  }

  private func _firstRange<S: StringProtocol>(of string: S) -> Range<Index>? {
    if #available(iOS 16.0, *) {
      return firstRange(of: string)
    } else {
      return range(of: string)
    }
  }
}

extension String {

  public func firstCapitalized() -> String {
    guard let first else {
      return self
    }
    var result = self
    result.replaceSubrange(startIndex...startIndex, with: String(first).capitalized)
    return result
  }

  public func joined(with optionalStrings: String?..., separator: String) -> String {
    var strings: [String] = [self]
    for optionalString in optionalStrings {
      if let string = optionalString {
        strings.append(string)
      }
    }
    return strings.joined(separator: separator)
  }

  public func results(matchesPattern pattern: String, options: NSRegularExpression.Options = []) throws -> [NSTextCheckingResult] {
    return try NSRegularExpression(pattern: pattern, options: options).matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
  }

  public mutating func replace<S: StringProtocol, C: Collection<Character>>(_ string: S, with replacementString: C) {
    var upperbound = endIndex
    while let rangeToReplace = range(of: string, options: .backwards, range: startIndex..<upperbound) {
      replaceSubrange(rangeToReplace, with: replacementString)
      upperbound = rangeToReplace.lowerBound
    }
  }

  public mutating func remove<S: StringProtocol>(_ string: S) {
    var upperbound = endIndex
    while let rangeToRemove = range(of: string, options: .backwards, range: startIndex..<upperbound) {
      removeSubrange(rangeToRemove)
      upperbound = rangeToRemove.lowerBound
    }
  }

  public mutating func removeCharacters(in set: CharacterSet) {
    unicodeScalars.removeAll(where: { set.contains($0) })
  }

  public mutating func removeCharacters(notIn set: CharacterSet) {
    unicodeScalars.removeAll(where: { !set.contains($0) })
  }

  public init?(resourceName: String, extension: String, in bundle: Bundle = .main) {
    guard let path = bundle.path(forResource: resourceName, ofType: `extension`) else {
      return nil
    }
    try? self.init(contentsOfFile: path)
  }

  @inlinable
  public var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
  }

  @inlinable
  public func localized(table: LocalizationTable? = nil, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
    return NSLocalizedString(self, tableName: table?.rawValue, bundle: bundle, value: value, comment: comment)
  }
}

extension Optional where Wrapped: StringProtocol {

  public var isNilOrBlank: Bool {
    switch self {
    case .none:
      return true
    case .some(let string):
      return string.isBlank
    }
  }

  /// Returns nil if the collection is nil or empty.
  public var nonBlank: Wrapped? {
    switch self {
    case .none:
      return nil
    case .some(let string):
      return string.isBlank ? nil : string
    }
  }
}
