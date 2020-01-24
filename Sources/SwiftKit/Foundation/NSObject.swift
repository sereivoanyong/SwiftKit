//
//  NSObject.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation

extension NSObject {
  
  @inlinable public func valueIfResponds(forKey key: String) -> Any? {
    if responds(to: Selector(key)) {
      return value(forKey: key)
    }
    return nil
  }
  
  @inlinable public func setValueIfResponds(_ value: Any?, forKey key: String) {
    if responds(to: Selector(key)) {
      setValue(value, forKey: key)
    }
  }
}
#endif
