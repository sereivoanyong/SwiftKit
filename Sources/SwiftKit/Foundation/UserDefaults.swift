//
//  UserDefaults.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(Foundation)
import Foundation

extension UserDefaults {
  
  final public subscript(key: String) -> PropertyListObject? {
    @inlinable get { return object(forKey: key) as! PropertyListObject? }
    @inlinable set { set(newValue, forKey: key) }
  }
}
#endif
