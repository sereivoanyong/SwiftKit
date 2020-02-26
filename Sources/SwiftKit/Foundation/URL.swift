//
//  URL.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

#if canImport(Foundation)
import Foundation
#if canImport(MobileCoreServices)
import MobileCoreServices

extension URL {
  
  public func mimeType() -> String? {
    // @see https://stackoverflow.com/a/40003309
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(), let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
      return mimetype as String
    }
    return nil
  }
}
#endif
#endif
