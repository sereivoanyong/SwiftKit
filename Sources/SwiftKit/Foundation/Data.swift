//
//  Data.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation

extension Data {
  
  @inlinable public init?(resourceName: String, extension: String, in bundle: Bundle = .main, options: ReadingOptions = []) {
    if let url = bundle.url(forResource: resourceName, withExtension: `extension`) {
      try? self.init(contentsOf: url, options: options)
    } else {
      return nil
    }
  }
  
  public func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
    return try JSONSerialization.jsonObject(with: self, options: options)
  }
  
  public func string(encoding: String.Encoding) -> String? {
    return String(data: self, encoding: encoding)
  }
}
#endif
