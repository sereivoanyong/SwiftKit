//
//  Version.swift
//
//  Created by Sereivoan Yong on 10/15/19.
//

import Foundation

/// Represents a version aligning to [SemVer 2.0.0](http://semver.org).
public struct Version {
  
  public let major: Int
  public let minor: Int?
  public let patch: Int?
  
  public init(major: Int = 0, minor: Int? = nil, patch: Int? = nil) {
    self.major = major
    self.minor = minor
    self.patch = patch
  }
  
  public init(string: String) {
    let components = string.split(separator: ".").map { Int($0)! }
    major = components[0]
    minor = components.indices.contains(1) ? components[1] : nil
    patch = components.indices.contains(2) ? components[2] : nil
  }
}

extension Version: Equatable {
  
  public static func == (lhs: Version, rhs: Version) -> Bool {
    return lhs.major == rhs.major && (lhs.minor ?? 0) == (rhs.minor ?? 0) && (lhs.patch ?? 0) == (rhs.patch ?? 0)
  }
}

extension Version: Comparable {
  
  private static func compare(lhs: Int, rhs: Int) -> ComparisonResult {
    if lhs < rhs {
      return .orderedAscending
    } else if lhs > rhs {
      return .orderedDescending
    } else {
      return .orderedSame
    }
  }
  
  public static func < (lhs: Version, rhs: Version) -> Bool {
    let majorComparison = Version.compare(lhs: lhs.major, rhs: rhs.major)
    if majorComparison != .orderedSame {
      return majorComparison == .orderedAscending
    }
    let minorComparison = Version.compare(lhs: lhs.minor ?? 0, rhs: rhs.minor ?? 0)
    if minorComparison != .orderedSame {
      return minorComparison == .orderedAscending
    }
    let patchComparison = Version.compare(lhs: lhs.patch ?? 0, rhs: rhs.patch ?? 0)
    if patchComparison != .orderedSame {
      return patchComparison == .orderedAscending
    }
    return false
  }
}

extension Version: Hashable {
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(major)
    hasher.combine(minor ?? 0)
    hasher.combine(patch ?? 0)
  }
}

extension Version: CustomStringConvertible {
  
  public var description: String {
    var string = "\(major)"
    if let minor = minor {
      string += ".\(minor)"
      if let patch = patch {
        string += ".\(patch)"
      }
    }
    return string
  }
}

extension Version: Codable {
  
  public init(from decoder: Decoder) throws {
    try self.init(string: decoder.singleValueContainer().decode(String.self))
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(description)
  }
}

extension Bundle {
  
  public var shortVersion: Version {
    return Version(string: infoDictionary!["CFBundleShortVersionString"] as! String)
  }
}
