//
//  Version.swift
//
//  Created by Sereivoan Yong on 10/15/19.
//

import Foundation

/// Represents a version aligning to [SemVer 2.0.0](http://semver.org).
public struct Version: RawRepresentable {

  public let major: Int

  public let minor: Int

  public let patch: Int

  public let rawValue: String

  public init(major: Int, minor: Int = 0, patch: Int = 0) {
    self.major = major
    self.minor = minor
    self.patch = patch
    self.rawValue = "\(major).\(minor).\(patch)"
  }

  public init?(rawValue: String) {
    let components = rawValue.split(separator: ".")
    let count = components.count
    guard count > 0, let major = Int(components[0]) else { return nil }

    let minor: Int
    if count > 1 {
      if let intComponent = Int(components[1]) {
        minor = intComponent
      } else {
        return nil
      }
    } else {
      minor = 0
    }

    let patch: Int
    if count > 2 {
      if let intComponent = Int(components[2]) {
        patch = intComponent
      } else {
        return nil
      }
    } else {
      patch = 0
    }

    self.init(major: major, minor: minor, patch: patch)
  }

  public init?(_ rawValue: String) {
    self.init(rawValue: rawValue)
  }
}

extension Version: Equatable {

  public static func == (lhs: Version, rhs: Version) -> Bool {
    return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
  }
}

extension Version: Comparable {

  public static func < (lhs: Version, rhs: Version) -> Bool {
    guard lhs.major == rhs.major else {
      return lhs.major < rhs.major
    }
    guard lhs.minor == rhs.minor else {
      return lhs.minor < rhs.minor
    }
    guard lhs.patch == rhs.patch else {
      return lhs.patch < rhs.patch
    }
    return false
  }
}

extension Version: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(major)
    hasher.combine(minor)
    hasher.combine(patch)
  }
}

extension Version: CustomStringConvertible {

  public var description: String {
    var string = "\(major).\(minor)"
    if patch > 0 {
      string += ".\(patch)"
    }
    return string
  }
}

extension Bundle {

  public var shortVersion: Version {
    return Version(infoDictionary!["CFBundleShortVersionString"] as! String)!
  }
}
