//
//  URL.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

import Foundation
import MobileCoreServices

public func fileExtension(mimeType: String) -> String? {
  guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil) else {
    return nil
  }
  return UTTypeCopyPreferredTagWithClass(uti.takeRetainedValue(), kUTTagClassFilenameExtension)?.takeRetainedValue() as String?
}

extension URL {

  public func mimeType() -> String? {
    // @see https://stackoverflow.com/a/40003309
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(), let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
      return mimeType as String
    }
    return nil
  }

  public mutating func append(_ string: String) {
    self = URL(string: absoluteString + string)!
  }
  
  @discardableResult
  public mutating func append(_ queryItems: URLQueryItem...) -> Bool {
    guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
      return false
    }
    components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
    self = components.url!
    return true
  }
}
