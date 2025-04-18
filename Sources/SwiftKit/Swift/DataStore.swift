//
//  DataStore.swift
//
//  Created by Sereivoan Yong on 12/13/22.
//

public protocol DataStore: AnyObject {

  func data(forKey key: String) -> Data?

  func set(_ data: Data?, forKey key: String)
}

#if canImport(Foundation)

import Foundation

// MARK: PropertyListStore

public protocol PropertyListStore: DataStore {

  func object(forKey key: String) -> Any?

  func set(_ value: Any?, forKey key: String)
}

extension PropertyListStore {

  public subscript<T: PropertyListObject>(key: String) -> T? {
    @inlinable get { return object(forKey: key) as? T }
    @inlinable set { set(newValue, forKey: key) }
  }
}

// MARK: UserDefaults

extension UserDefaults: PropertyListStore {

  public func set(_ data: Data?, forKey key: String) {
    set(data as Any?, forKey: key)
  }
}

// MARK: NSUbiquitousKeyValueStore

extension NSUbiquitousKeyValueStore: PropertyListStore {
}

#endif
