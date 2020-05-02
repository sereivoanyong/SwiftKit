//
//  UserDefault.swift
//
//  Created by Sereivoan Yong on 11/25/19.
//

#if canImport(Foundation)
import Foundation

/*
 struct UserPreferences {
   
   @UserDefault(key: "IsFirstOpen", defaultValue: true)
   var isFirstOpen: Bool
 }
 */

@propertyWrapper public struct UserDefault<Value> {
  
  private let userDefaults: UserDefaults
  private let key: String
  private let defaultValue: () -> Value
  
  public init(userDefaults: UserDefaults = .standard, key: String, defaultValue: @autoclosure @escaping () -> Value) {
    self.userDefaults = userDefaults
    self.key = key
    self.defaultValue = defaultValue
  }
  
  public var wrappedValue: Value {
    get { userDefaults.value(forKey: key) as? Value ?? defaultValue() }
    set { userDefaults.set(newValue, forKey: key) }
  }
}

@propertyWrapper public struct OptionalUserDefault<Value> {
  
  private let userDefaults: UserDefaults
  private let key: String
  private let defaultValue: () -> Value?
  
  public init(userDefaults: UserDefaults = .standard, key: String, defaultValue: @autoclosure @escaping () -> Value? = nil) {
    self.userDefaults = userDefaults
    self.key = key
    self.defaultValue = defaultValue
  }
  
  public var wrappedValue: Value? {
    get { userDefaults.value(forKey: key) as? Value ?? defaultValue() }
    set { userDefaults.set(newValue, forKey: key) }
  }
}
#endif
