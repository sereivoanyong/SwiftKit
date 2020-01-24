//
//  String.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation

extension String {
  
  /// For Emoji Encoded, use `encoded(to: .utf8, from: .nonLossyASCII, allowLossyConversion: true)`
  /// For Emoji Decoded, use `encoded(to: .nonLossyASCII, from: .utf8, allowLossyConversion: true)`
  public func encoded(to toEncoding: Encoding, from fromEncoding: Encoding, allowLossyConversion: Bool = true) -> String? {
    return data(using: fromEncoding, allowLossyConversion: allowLossyConversion).flatMap { String(data: $0, encoding: toEncoding) }
  }
  
  public func firstCapitalized() -> String {
    guard let firstCharacter = first else {
      return self
    }
    var result = self
    result.replaceSubrange(startIndex...startIndex, with: String(firstCharacter).capitalized)
    return result
  }
  
  public var isBlank: Bool {
    return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  public var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  public func strippingCharacters(in characterSet: CharacterSet) -> String {
    return components(separatedBy: characterSet.inverted).joined()
  }
  
  public func results(matchesPattern pattern: String, options: NSRegularExpression.Options = []) throws -> [NSTextCheckingResult] {
    return try NSRegularExpression(pattern: pattern, options: options).matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
  }
  
  public var boolValue: Bool? {
    switch lowercased() {
    case "true", "yes", "1":
      return true
    case "false", "no", "0":
      return false
    default:
      return nil
    }
  }
  
  func indices(of string: String, options: CompareOptions = [], locale: Locale? = nil) -> [Int] {
    return ranges(of: string, options: options, locale: locale).map { distance(from: startIndex, to: $0.lowerBound) }
  }
  
  func ranges(of string: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {
    var ranges: [Range<String.Index>] = []
    var position = startIndex
    while let range = range(of: string, options: options, range: position..<endIndex, locale: locale) {
      ranges.append(range)
      position = range.upperBound
    }
    return ranges
  }
  
  public mutating func replace(_ string: String, with replacementString: String) {
    var upperbound = endIndex
    while let rangeToReplace = range(of: string, options: .backwards, range: startIndex..<upperbound) {
      replaceSubrange(rangeToReplace, with: replacementString)
      upperbound = rangeToReplace.lowerBound
    }
  }
  
  public mutating func remove(_ string: String) {
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
  
  /*
  func indices(of occurrence: String) -> [Int] {
    var indices = [Int]()
    var position = startIndex
    while let range = range(of: occurrence, range: position..<endIndex) {
      indices.append(distance(from: startIndex, to: range.lowerBound))
      position = range.upperBound
    }
    return indices
  }
  
  func ranges(of searchString: String) -> [Range<String.Index>] {
    let count = searchString.count
    return indices(of: searchString).map { index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0 + count) }
  }
  */
  
  public func removing(_ string: String) -> String {
    var mutatingSelf = self
    mutatingSelf.remove(string)
    return mutatingSelf
  }
  
  @inlinable public init?(resourceName: String, extension: String, in bundle: Bundle = .main) {
    if let path = bundle.path(forResource: resourceName, ofType: `extension`) {
      try? self.init(contentsOfFile: path)
    } else {
      return nil
    }
  }
  
  @inlinable public var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
  }
  
  @inlinable public func localized(tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
    return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
  }
  
  @inlinable public func formatLocalized(tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "", _ arguments: CVarArg...) -> String {
    let format = NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    return withVaList(arguments) { parameter in
      NSString(format: format, locale: Locale.current, arguments: parameter)
    } as String
  }
}

#endif
