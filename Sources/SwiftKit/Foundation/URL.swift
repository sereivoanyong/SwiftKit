//
//  URL.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

#if canImport(Foundation)
import Foundation

extension URL {
  
  public mutating func append(_ string: String) {
    self = URL(string: absoluteString + string)!
  }
}
#if canImport(MobileCoreServices)
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
}
#endif
#endif
