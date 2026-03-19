//
//  HTTPBody.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/19/26.
//

import Foundation

public enum HTTPBody {

  case json([String: Any])
  case formURLEncoded([String: Any])
  case multipart(MultipartFormData)
  case raw(Data, contentType: String)

  public var contentType: String {
    switch self {
    case .json:
      return "application/json"
    case .formURLEncoded:
      return "application/x-www-form-urlencoded"
    case .multipart(let form):
      return "multipart/form-data; boundary=\(form.boundary)"
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

    case .multipart(let form):
      return encodeMultipart(form)

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

  private func encodeMultipart(_ form: MultipartFormData) -> Data {
    var data = Data()
    let crlf = "\r\n"
    let boundaryPrefix = "--\(form.boundary)"

    for part in form.parts {
      data.append("\(boundaryPrefix)\(crlf)")

      var disposition = "Content-Disposition: form-data; name=\"\(part.name)\""
      if let filename = part.filename {
        disposition += "; filename=\"\(filename)\""
      }
      data.append("\(disposition)\(crlf)")

      if let mimeType = part.mimeType {
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

  fileprivate mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}

extension URLRequest {

  public mutating func setHTTPBody(_ body: HTTPBody) {
    httpBody = body.encoded()
    setValue(body.contentType, forHTTPHeaderField: "Content-Type")
  }
}
