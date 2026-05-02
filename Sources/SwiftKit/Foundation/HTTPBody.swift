//
//  HTTPBody.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/19/26.
//

import Foundation
import UniformTypeIdentifiers

extension HTTPBody {

  public enum FormData {

    case text(name: String, value: String)

    case json(name: String, data: Data)

    case file(name: String, filename: String, mimeType: String?, data: Data)

    case data(name: String, mimeType: String, data: Data)

    @inlinable
    public var data: Data {
      switch self {
      case .text(_, let value):
        return Data(value.utf8)
      case .json(_, let data):
        return data
      case .file(_, _, _, let data):
        return data
      case .data(_, _, let data):
        return data
      }
    }

    public static func json(name: String, object: Any, options: JSONSerialization.WritingOptions = []) throws -> Self {
      return json(name: name, data: try JSONSerialization.data(withJSONObject: object, options: options))
    }

    public static func file(name: String, fileURL: URL, options: Data.ReadingOptions = [], mimeType: String?) throws -> Self {
      return file(name: name, filename: fileURL.lastPathComponent, mimeType: mimeType, data: try Data(contentsOf: fileURL, options: options))
    }

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    public static func file(name: String, fileURL: URL, options: Data.ReadingOptions = []) throws -> Self {
      return try file(name: name, fileURL: fileURL, options: options, mimeType: UTType(filenameExtension: fileURL.pathExtension)?.preferredMIMEType)
    }
  }
}

public enum HTTPBody {

  case json([String: Any])
  case formURLEncoded([String: Any])
  case multipartFormData([FormData], boundary: String = UUID().uuidString)
  case raw(Data, contentType: String)

  public var contentType: String {
    switch self {
    case .json:
      return "application/json"
    case .formURLEncoded:
      return "application/x-www-form-urlencoded"
    case .multipartFormData(_, let boundary):
      return "multipart/form-data; boundary=\(boundary)"
    case .raw(_, let contentType):
      return contentType
    }
  }

  public func encoded() -> Data? {
    switch self {
    case .json(let dict):
      return try? JSONSerialization.data(withJSONObject: dict)

    case .formURLEncoded(let dict):
      return encodeFormURLBody(dict).data(using: .utf8)

    case .multipartFormData(let parts, let boundary):
      return encodeMultipartFormData(parts, boundary: boundary)

    case .raw(let data, _):
      return data
    }
  }

  // MARK: form-urlencoded

  private func encodeFormURLBody(_ dict: [String: Any], prefix: String? = nil) -> String {
    var parts: [String] = []
    for (key, value) in dict {
      let encodedKey = prefix.map { "\($0)[\(key)]" } ?? key
      parts.append(contentsOf: encodePart(key: encodedKey, value: value))
    }
    return parts.joined(separator: "&")
  }

  private func encodePart(key: String, value: Any) -> [String] {
    if let dict = value as? [String: Any] {
      return dict.flatMap { encodePart(key: "\(key)[\($0)]", value: $1) }
    } else if let array = value as? [Any] {
      return array.enumerated().flatMap { encodePart(key: "\(key)[\($0)]", value: $1) }
    } else {
      let encodedValue = (value as? String ?? "\(value)").percentEncoded()
      return ["\(key)=\(encodedValue)"]
    }
  }

  // MARK: multipart/form-data

  private func encodeMultipartFormData(_ parts: [FormData], boundary: String) -> Data {
    var data = Data()
    let crlf = "\r\n"
    let boundaryPrefix = "--\(boundary)"

    for part in parts {
      data.append("\(boundaryPrefix)\(crlf)")

      switch part {
      case .text(let name, _):
        data.append("Content-Disposition: form-data; name=\"\(name)\"\(crlf)")
      case .json(let name, _):
        data.append("Content-Disposition: form-data; name=\"\(name)\"\(crlf)")
        data.append("Content-Type: application/json\(crlf)")
      case .file(let name, let filename, let mimeType, _):
        data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\(crlf)")
        data.append("Content-Type: \(mimeType ?? "application/octet-stream")\(crlf)")
      case .data(let name, let mimeType, _):
        data.append("Content-Disposition: form-data; name=\"\(name)\"\(crlf)")
        data.append("Content-Type: \(mimeType)\(crlf)")
      }

      data.append(crlf)
      data.append(part.data)
      data.append(crlf)
    }

    data.append("\(boundaryPrefix)--\(crlf)")
    return data
  }
}

extension Data {

  @inlinable
  mutating func append(_ string: String) {
    append(Data(string.utf8))
  }
}

extension URLRequest {

  public mutating func setHTTPBody(_ body: HTTPBody) {
    httpBody = body.encoded()
    setValue(body.contentType, forHTTPHeaderField: "Content-Type")
  }
}
