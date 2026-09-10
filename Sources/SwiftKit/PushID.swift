//
//  PushID.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/10/26.
//

#if canImport(Foundation)

import Foundation

private let pushCharacters: [Character] = [Character]("-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz")
private let pushCharacterIndices: [Character: Int64] = pushCharacters.enumerated().reduce(into: [:]) { result, pair in
  let (index, character) = pair
  result[character] = Int64(index)
}

final private class RandomCharacterGenerator: @unchecked Sendable {

  private let lock = NSLock()
  private var lastPushTime: Int64 = 0
  private var lastRandomCharacterIndices: [Int] = [Int](repeating: 0, count: 12)

  static let shared = RandomCharacterGenerator()

  func randomCharacterIndices(for time: Int64) -> [Int] {
    lock.lock()

    let isDuplicateTime = time == lastPushTime
    lastPushTime = time

    if !isDuplicateTime {
      for i in 0..<12 {
        lastRandomCharacterIndices[i] = .random(in: 0..<64)
      }
    } else {
      var i = 11
      while i >= 0 && lastRandomCharacterIndices[i] == 63 {
        lastRandomCharacterIndices[i] = 0
        i -= 1
      }
      if i >= 0 {
        lastRandomCharacterIndices[i] += 1
      }
    }
    let lastRandomCharacterIndices = lastRandomCharacterIndices
    lock.unlock()
    return lastRandomCharacterIndices
  }
}

/// Swift version of Firebase database's `FNextPushId`
nonisolated public struct PushID: Hashable, Sendable {

  private static let timeCharacterCount: Int = 8
  private static let randomCharacterCount: Int = 12

  public let date: Date

  public let string: String

  public var timeString: Substring {
    return string.prefix(Self.timeCharacterCount)
  }

  public var randomString: Substring {
    return string.suffix(Self.randomCharacterCount)
  }

  public init(unchecked string: String) {
    var time: Int64 = 0
    for character in string.prefix(Self.timeCharacterCount) {
      let value = pushCharacterIndices[character]!
      time = (time * 64) + value
    }
    self.date = Date(timeIntervalSince1970: TimeInterval(time) / 1000.0)
    self.string = string
  }

  public init?(_ string: String) {
    guard string.count == Self.timeCharacterCount + Self.randomCharacterCount else { return nil }
    var time: Int64 = 0
    for character in string.prefix(Self.timeCharacterCount) {
      guard let value = pushCharacterIndices[character] else { return nil }
      time = (time * 64) + value
    }
    for character in string.suffix(Self.randomCharacterCount) {
      guard pushCharacterIndices[character] != nil else { return nil }
    }
    self.date = Date(timeIntervalSince1970: TimeInterval(time) / 1000.0)
    self.string = string
  }

  public init(_ date: Date) {
    let time = Int64(date.timeIntervalSince1970 * 1000.0)

    var timeCharacters = [Character](repeating: "-", count: Self.timeCharacterCount)
    do {
      var time = time
      for i in stride(from: Self.timeCharacterCount - 1, through: 0, by: -1) {
        timeCharacters[i] = pushCharacters[Int(time % 64)]
        time /= 64
      }
    }

    var characters = timeCharacters

    let randomPartIndices = RandomCharacterGenerator.shared.randomCharacterIndices(for: time)
    for index in randomPartIndices {
      characters.append(pushCharacters[index])
    }

    self.date = date
    self.string = String(characters)
  }

  public static func next() -> Self {
    return Self(.now)
  }

  public static func isValid(_ string: String) -> Bool {
    guard string.count == Self.timeCharacterCount + Self.randomCharacterCount else { return false }
    return string.allSatisfy { pushCharacterIndices[$0] != nil }
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.string == rhs.string
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(string)
  }
}

extension PushID: CustomStringConvertible {

  public var description: String {
    return string
  }
}

extension PushID: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    guard let instance = Self(string) else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid Push ID format: \(string)")
    }
    self = instance
  }
}

extension PushID: Encodable {

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(string)
  }
}

#endif
