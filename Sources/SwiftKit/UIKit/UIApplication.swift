//
//  UIApplicationswift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UIApplication {
  
  public static var openSettingsURL: URL {
    return URL(string: openSettingsURLString)!
  }
  
  @available(iOS 10.0, *)
  @discardableResult
  final public func openIfPossible(_ url: URL?, options: [OpenExternalURLOptionsKey: Any]? = nil, completion: ((Bool) -> Void)? = nil) -> Bool {
    guard let url = url, canOpenURL(url) else {
      return false
    }
    open(url, options: options ?? [:], completionHandler: completion)
    return true
  }
  
  @available(iOS 10.0, *)
  @discardableResult
  final public func openAppOnAppStore(identifier: String, completion: ((Bool) -> Void)? = nil) -> Bool {
    return openIfPossible(URL(string: "itms-apps://itunes.apple.com/app/id\(identifier)")!, completion: completion)
  }
}
#endif
