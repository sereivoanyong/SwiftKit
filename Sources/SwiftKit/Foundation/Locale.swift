//
//  Locale.swift
//
//  Created by Sereivoan Yong on 6/5/20.
//

import Foundation

extension Locale {

  public static let enUSPOSIX: Locale = Locale(identifier: "en_US_POSIX")

  public init(localization: String) {
    let components = Self.components(fromIdentifier: localization)
    if let languageCode = components[NSLocale.Key.languageCode.rawValue] {
      var identifier = languageCode
      if let scriptCode = components[NSLocale.Key.scriptCode.rawValue] {
        identifier += "_" + scriptCode
      }
      if let regionCode = components[NSLocale.Key.countryCode.rawValue] {
        identifier += "_" + regionCode
      }
      self.init(identifier: identifier)
    } else {
      self.init(identifier: localization)
    }
  }

  public static func emojiFlag(forRegionCode regionCode: String) -> String {
    assert(regionCode.count == 2 && regionCode == regionCode.uppercased())
    var flagScalars = String.UnicodeScalarView()
    let base = ("🇦" as Unicode.Scalar).value - ("A" as Unicode.Scalar).value
    for scalar in regionCode.unicodeScalars {
      if let flagScalar = Unicode.Scalar(base + scalar.value) {
        flagScalars.append(flagScalar)
      }
    }
    return String(flagScalars)
  }
}
