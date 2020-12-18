//
//  Locale.swift
//
//  Created by Sereivoan Yong on 6/5/20.
//

#if canImport(Foundation)
import Foundation

extension Locale {
  
  @available(*, deprecated, renamed: "emojiFlag(forRegionCode:)")
  public static func flagEmoji(forRegionCode regionCode: String) -> String {
    return emojiFlag(forRegionCode: regionCode)
  }
  
  @available(iOS 9.0, *)
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
#endif
