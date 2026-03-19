//
//  MultipartFormData.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/19/26.
//

import Foundation
import UniformTypeIdentifiers

public struct MultipartFormData {

  public struct Part {

    public let name: String
    public let data: Data
    public let filename: String?
    public let mimeType: String?

    public init(name: String, data: Data, filename: String? = nil, mimeType: String? = nil) {
      self.name = name
      self.data = data
      self.filename = filename
      self.mimeType = mimeType
    }

    public init(name: String, string: String, encoding: String.Encoding = .utf8) {
      self.name = name
      self.data = string.data(using: encoding) ?? Data()
      self.filename = nil
      self.mimeType = "text/plain"
    }

    public init(name: String, jsonObject: Any, options: JSONSerialization.WritingOptions = []) throws {
      self.name = name
      self.data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
      self.filename = nil
      self.mimeType = "application/json"
    }

    public init(name: String, fileURL: URL, options: Data.ReadingOptions = [], mimeType: String?) throws {
      self.name = name
      self.data = try Data(contentsOf: fileURL, options: options)
      self.filename = fileURL.lastPathComponent
      self.mimeType = mimeType
    }

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    public init(name: String, fileURL: URL, options: Data.ReadingOptions = []) throws {
      try self.init(name: name, fileURL: fileURL, options: options, mimeType: UTType(filenameExtension: fileURL.pathExtension)?.preferredMIMEType)
    }
  }

  public let parts: [Part]
  public let boundary: String

  public init(parts: [Part], boundary: String = UUID().uuidString) {
    self.parts = parts
    self.boundary = boundary
  }
}
