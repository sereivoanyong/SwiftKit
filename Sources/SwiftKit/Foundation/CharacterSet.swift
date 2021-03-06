//
//  CharacterSet.swift
//
//  Created by Sereivoan Yong on 7/7/20.
//

#if canImport(Foundation)
import Foundation

extension CharacterSet {
  
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
#endif
