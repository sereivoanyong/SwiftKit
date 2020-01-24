//
//  UserDefaults.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(Foundation)
import Foundation

extension UserDefaults {
  
  final public subscript(key: String) -> Any? {
    @inlinable get { return object(forKey: key) }
    @inlinable set { set(newValue, forKey: key) }
  }
}
#endif
