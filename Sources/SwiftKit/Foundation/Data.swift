//
//  Data.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import Foundation

extension Data {

  public init?(resourceName: String, extension: String, in bundle: Bundle = .main, options: ReadingOptions = []) {
    guard let url = bundle.url(forResource: resourceName, withExtension: `extension`) else {
      return nil
    }
    try? self.init(contentsOf: url, options: options)
  }
  
  public var mimeType: String {
    var b: UInt8 = 0
    copyBytes(to: &b, count: 1)
    switch b {
    case 0xFF:
      return "image/jpeg"
    case 0x89:
      return "image/png"
    case 0x47:
      return "image/gif"
    case 0x4D, 0x49:
      return "image/tiff"
    case 0x25:
      return "application/pdf"
    case 0xD0:
      return "application/vnd"
    case 0x46:
      return "text/plain"
    default:
      return "application/octet-stream"
    }
  }
  
  public func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
    return try JSONSerialization.jsonObject(with: self, options: options)
  }
  
  public func string(encoding: String.Encoding) -> String? {
    return String(data: self, encoding: encoding)
  }

  @available(iOS 14.0, *)
  public struct HexEncodingOptions: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

    public static let uppercase: Self = Self(rawValue: 1 << 0)
  }

  @available(iOS 14.0, *)
  public func hexEncodedString(options: HexEncodingOptions = []) -> String {
    let hexDigits = options.contains(.uppercase) ? "0123456789ABCDEF" : "0123456789abcdef"
    let utf8HexDigits = ContiguousArray<UInt8>(hexDigits.utf8)
    let count = count
    return String(unsafeUninitializedCapacity: 2 * count) { bufferPtr in
      var ptr = bufferPtr.baseAddress.unsafelyUnwrapped
      for byte in self {
        ptr[0] = utf8HexDigits[Int(byte / 16)]
        ptr[1] = utf8HexDigits[Int(byte % 16)]
        ptr += 2
      }
      return 2 * count
    }
  }
}
