//
//  WKWebView.swift
//
//  Created by Sereivoan Yong on 10/5/23.
//

import WebKit

extension WKWebView {

  public struct Request {

    let isFile: Bool
    fileprivate let loadHandler: (WKWebView) -> WKNavigation?

    private init(isFile: Bool = false, loadHandler: @escaping (WKWebView) -> WKNavigation?) {
      self.isFile = isFile
      self.loadHandler = loadHandler
    }
  }

  @discardableResult
  public func load(_ request: Request) -> WKNavigation? {
    return request.loadHandler(self)
  }
}

extension WKWebView.Request {

  public static func url(_ request: URLRequest) -> Self {
    return .init { webView in
      return webView.load(request)
    }
  }

  public static func url(_ url: URL) -> Self {
    return .init { webView in
      return webView.load(URLRequest(url: url))
    }
  }

  public static func fileURL(_ url: URL, readAccessURL: URL) -> Self {
    return .init(isFile: true) { webView in
      return webView.loadFileURL(url, allowingReadAccessTo: readAccessURL)
    }
  }

  @available(iOS 15.0, *)
  public static func fileURL(_ request: URLRequest, readAccessURL: URL) -> Self {
    return .init(isFile: true) { webView in
      return webView.loadFileRequest(request, allowingReadAccessTo: readAccessURL)
    }
  }

  public static func html(_ string: String, baseURL: URL?) -> Self {
    return .init { webView in
      return webView.loadHTMLString(string, baseURL: baseURL)
    }
  }

  public static func data(_ data: Data, mimeType: String, characterEncodingName: String, baseURL: URL) -> Self {
    return .init { webView in
      return webView.load(data, mimeType: mimeType, characterEncodingName: characterEncodingName, baseURL: baseURL)
    }
  }

  @available(iOS 15.0, *)
  public static func simulated(_ request: URLRequest, response: URLResponse, responseData: Data) -> Self {
    return .init { webView in
      return webView.loadSimulatedRequest(request, response: response, responseData: responseData)
    }
  }

  @available(iOS 15.0, *)
  public static func simulated(_ request: URLRequest, responseHTMLString: String) -> Self {
    return .init { webView in
      return webView.loadSimulatedRequest(request, responseHTML: responseHTMLString)
    }
  }
}
