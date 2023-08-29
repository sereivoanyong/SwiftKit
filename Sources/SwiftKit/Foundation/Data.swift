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
}
