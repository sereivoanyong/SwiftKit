//
//  UIApplication.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UIApplication {

  /// The top most view controller of the app's key window
  public var keyTopMostViewController: UIViewController? {
    return keyWindow?.rootViewController?.topMostViewController
  }

  public static var openSettingsURL: URL? {
    return URL(string: openSettingsURLString)
  }
  
  @available(iOS 15.4, *)
  public static var openNotificationSettingsURL: URL? {
    if #available(iOS 16.0, *) {
      return URL(string: openNotificationSettingsURLString)
    }
    return URL(string: UIApplicationOpenNotificationSettingsURLString)
  }

  public static func appURL(id: String) -> URL {
    return URL(string: "https://apps.apple.com/app/id\(id)")!
  }

  @available(iOS 10.0, *)
  @discardableResult
  public func openIfPossible(_ url: URL?, options: [OpenExternalURLOptionsKey: Any]? = nil, completion: ((Bool) -> Void)? = nil) -> Bool {
    guard let url = url, canOpenURL(url) else {
      return false
    }
    open(url, options: options ?? [:], completionHandler: completion)
    return true
  }

  @available(iOS 10.0, *)
  @discardableResult
  public func openAppOnAppStore(identifier: String, completion: ((Bool) -> Void)? = nil) -> Bool {
    return openIfPossible(URL(string: "itms-apps://itunes.apple.com/app/id\(identifier)")!, completion: completion)
  }
}
#endif
