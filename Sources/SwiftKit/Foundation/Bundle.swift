//
//  Bundle.swift
//
//  Created by Sereivoan Yong on 2/22/22.
//

import Foundation

extension Bundle {

  final public func displayNameWithShortVersionAndVersion() -> String? {
    guard let infoDictionary = infoDictionary, let displayName = infoDictionary["CFBundleDisplayName"] as? String ?? infoDictionary["CFBundleName"] as? String else {
      return nil
    }
    var string = displayName
    if let shortVersionString = infoDictionary["CFBundleShortVersionString"] as? String {
      string += " " + shortVersionString
    }
    if let versionString = infoDictionary["CFBundleVersion"] as? String {
      string += " (" + versionString + ")"
    }
    return string
  }
}
