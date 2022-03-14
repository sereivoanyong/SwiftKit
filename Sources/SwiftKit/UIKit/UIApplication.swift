//
//  UIApplication.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UIApplication {

  /// The top most view controller of the app's key window
  final public var keyTopMostViewController: UIViewController? {
    keyWindow?.rootViewController?.topMostViewController
  }

  public static var openSettingsURL: URL {
    URL(string: openSettingsURLString)!
  }

  public static func appURL(id: String) -> URL {
    return URL(string: "https://apps.apple.com/app/id\(id)")!
  }

  @available(iOS 10.0, *)
  @available(iOSApplicationExtension, unavailable)
  @discardableResult
  final public func openIfPossible(_ url: URL?, options: [OpenExternalURLOptionsKey: Any]? = nil, completion: ((Bool) -> Void)? = nil) -> Bool {
    guard let url = url, canOpenURL(url) else {
      return false
    }
    open(url, options: options ?? [:], completionHandler: completion)
    return true
  }

  @available(iOS 10.0, *)
  @available(iOSApplicationExtension, unavailable)
  @discardableResult
  final public func openAppOnAppStore(identifier: String, completion: ((Bool) -> Void)? = nil) -> Bool {
    return openIfPossible(URL(string: "itms-apps://itunes.apple.com/app/id\(identifier)")!, completion: completion)
  }
}
#endif
