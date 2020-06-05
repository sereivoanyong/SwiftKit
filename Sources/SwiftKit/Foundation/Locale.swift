//
//  Locale.swift
//
//  Created by Sereivoan Yong on 6/5/20.
//

import Foundation

extension Locale {
  
  public static func flagEmoji(forRegionCode regionCode: String) -> String {
    var flagScalars = String.UnicodeScalarView()
    let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
    for scalar in regionCode.uppercased().unicodeScalars {
      if let scalar = Unicode.Scalar(base + scalar.value) {
        flagScalars.append(scalar)
      }
    }
    return String(flagScalars)
  }
}
