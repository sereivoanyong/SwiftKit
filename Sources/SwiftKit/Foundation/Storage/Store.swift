//
//  Store.swift
//
//  Created by Sereivoan Yong on 12/13/22.
//

#if canImport(Foundation)

import Foundation

public protocol Store: AnyObject {

  func object(forKey key: String) -> Any?

  func set(_ value: Any?, forKey key: String)
}

extension Store {

  public subscript(key: String) -> PropertyListObject? {
    @inlinable get { return object(forKey: key) as! PropertyListObject? }
    @inlinable set { set(newValue, forKey: key) }
  }
}

// MARK: UserDefaults

extension UserDefaults: Store { }

extension Store where Self == UserDefaults {

  public static var standardDefaults: Self {
    return UserDefaults.standard
  }
}

// MARK: NSUbiquitousKeyValueStore

extension NSUbiquitousKeyValueStore: Store { }

extension Store where Self == NSUbiquitousKeyValueStore {

  public static var defaultUbiquitous: Self {
    return NSUbiquitousKeyValueStore.default
  }
}

#endif
