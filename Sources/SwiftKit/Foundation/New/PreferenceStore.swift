//
//  PreferenceStore.swift
//
//  Created by Sereivoan Yong on 12/13/22.
//

import Foundation

public protocol PreferenceStore: AnyObject {

  func object(forKey key: String) -> Any?

  func set(_ value: Any?, forKey key: String)
}

extension PreferenceStore {

  public subscript(key: String) -> PropertyListObject? {
    @inlinable get { return object(forKey: key) as! PropertyListObject? }
    @inlinable set { set(newValue, forKey: key) }
  }
}

extension UserDefaults: PreferenceStore { }

extension NSUbiquitousKeyValueStore: PreferenceStore { }

extension PreferenceStore where Self == UserDefaults {

  public static var standardUserDefaults: Self {
    return UserDefaults.standard
  }
}

extension PreferenceStore where Self == NSUbiquitousKeyValueStore {

  public static var defaultUbiquitousStore: Self {
    return NSUbiquitousKeyValueStore.default
  }
}
