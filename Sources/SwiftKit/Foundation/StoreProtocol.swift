//
//  StoreProtocol.swift
//
//  Created by Sereivoan Yong on 12/13/22.
//

#if canImport(Foundation)
import Foundation

public protocol StoreProtocol: AnyObject {

  func object(forKey key: String) -> Any?

  func set(_ value: Any?, forKey key: String)
}

extension StoreProtocol {

  public subscript(key: String) -> PropertyListObject? {
    @inlinable get { return object(forKey: key) as! PropertyListObject? }
    @inlinable set { set(newValue, forKey: key) }
  }
}

extension UserDefaults: StoreProtocol { }

extension NSUbiquitousKeyValueStore: StoreProtocol { }

extension StoreProtocol where Self == UserDefaults {

  public static var standardUserDefaults: Self {
    return UserDefaults.standard
  }
}

extension StoreProtocol where Self == NSUbiquitousKeyValueStore {

  public static var defaultUbiquitousStore: Self {
    return NSUbiquitousKeyValueStore.default
  }
}
#endif
