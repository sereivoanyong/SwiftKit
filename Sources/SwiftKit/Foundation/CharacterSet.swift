//
//  CharacterSet.swift
//
//  Created by Sereivoan Yong on 7/7/20.
//

import Foundation

extension CharacterSet {

  /// Creates a CharacterSet from RFC 3986 allowed characters.
  ///
  /// RFC 3986 states that the following characters are "reserved" characters.
  ///
  /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
  /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
  ///
  /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
  /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
  /// should be percent-escaped in the query string.
  public static let rfc3986URLQueryAllowed: CharacterSet = {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
  }()

  // @see: https://stackoverflow.com/a/53176850/11235826
  public static let urlAllowed: CharacterSet = {
    var set = CharacterSet(charactersIn: "#")
    set.formUnion(urlUserAllowed)
    set.formUnion(urlPasswordAllowed)
    set.formUnion(urlHostAllowed)
    set.formUnion(urlPathAllowed)
    set.formUnion(urlQueryAllowed)
    set.formUnion(urlFragmentAllowed)
    return set
  }()

  public func characters() -> [Character] {
    return unicodeScalars().map(Character.init)
  }

  // @see: https://stackoverflow.com/a/52133647/11235826
  public func unicodeScalars() -> String.UnicodeScalarView {
    var unicodeScalars: [UnicodeScalar] = []
    var plane: UInt8 = 0
    // following documentation at https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
    for (i, w) in bitmapRepresentation.enumerated() {
      let k = i % 0x2001
      if k == 0x2000 {
        // plane index byte
        plane = w << 13
        continue
      }
      let base = (UInt32(plane) + UInt32(k)) << 3
      for j: UInt32 in 0..<8 where w & 1 << j != 0 {
        if let unicodeScalar = UnicodeScalar(base + j) {
          unicodeScalars.append(unicodeScalar)
        }
      }
    }
    return String.UnicodeScalarView(unicodeScalars)
  }
}

extension String {

  public func percentEncoded() -> String {
    return addingPercentEncoding(withAllowedCharacters: .rfc3986URLQueryAllowed) ?? self
  }
}
