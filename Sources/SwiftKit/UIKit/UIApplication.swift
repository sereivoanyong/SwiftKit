//
//  UIApplication.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

import UIKit

extension UIApplication {

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

  @discardableResult
  public func openIfPossible(_ url: URL?, options: [OpenExternalURLOptionsKey: Any]? = nil, completion: ((Bool) -> Void)? = nil) -> Bool {
    guard let url, canOpenURL(url) else {
      return false
    }
    open(url, options: options ?? [:], completionHandler: completion)
    return true
  }

  @discardableResult
  public func openAppOnAppStore(identifier: String, completion: ((Bool) -> Void)? = nil) -> Bool {
    return openIfPossible(URL(string: "itms-apps://itunes.apple.com/app/id\(identifier)")!, completion: completion)
  }
}
