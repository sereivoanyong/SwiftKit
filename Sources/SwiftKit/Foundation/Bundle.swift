//
//  Bundle.swift
//
//  Created by Sereivoan Yong on 2/22/22.
//

#if canImport(Foundation)
import Foundation

extension Bundle {

  /// MyApp 1.0 (1)
  /// {CFBundleDisplayName} {CFBundleShortVersionString} ({CFBundleVersion})
  public func displayNameWithShortVersionAndVersion() -> String? {
    guard let infoDictionary = infoDictionary, let displayName = infoDictionary["CFBundleDisplayName"] as? String ?? infoDictionary[kCFBundleNameKey as String] as? String else {
      return nil
    }
    var string = displayName
    if let shortVersionString = infoDictionary["CFBundleShortVersionString"] as? String {
      string += " " + shortVersionString
    }
    if let versionString = infoDictionary[kCFBundleVersionKey as String] as? String {
      string += " (" + versionString + ")"
    }
    return string
  }
}
#endif
