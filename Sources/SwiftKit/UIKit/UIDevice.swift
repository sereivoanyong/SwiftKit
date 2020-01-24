//
//  UIDevice.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

extension UIDevice {
  
  final public func deviceInfo<T>(forKey key: String) -> T? {
    return performIfResponds(Selector(("_deviceInfoForKey:")), with: key as NSString) as? T
  }
}
#endif
