//
//  UserDefault.swift
//
//  Created by Sereivoan Yong on 11/25/19.
//

#if canImport(Foundation)
import Foundation

/*
 enum UserPreferences {
   
   @UserDefault(key: "IsFirstOpen", default: true)
   var isFirstOpen: Bool
 }
 */

@propertyWrapper public struct UserDefault<Object> {

  private let get: () -> Object
  private let set: (Object) -> Void

  @available(*, deprecated, renamed: "init(userDefaults:key:default:)")
  public init(userDefaults: UserDefaults = .standard, key: String, defaultValue: @autoclosure @escaping () -> Object) {
    get = { userDefaults.object(forKey: key) as? Object ?? defaultValue() }
    set = { newObject in userDefaults.set(newObject, forKey: key) }
  }

  public init(userDefaults: UserDefaults = .standard, key: String, default defaultObject: @autoclosure @escaping () -> Object) where Object: PropertyListObject {
    get = { userDefaults.object(forKey: key) as? Object ?? defaultObject() }
    set = { newObject in userDefaults.set(newObject, forKey: key) }
  }

  public init(userDefaults: UserDefaults = .standard, key: String, default defaultObject: @autoclosure @escaping () -> Object) where Object: RawRepresentable, Object.RawValue: PropertyListObject {
    get = { (userDefaults.object(forKey: key) as? Object.RawValue).flatMap(Object.init(rawValue:)) ?? defaultObject() }
    set = { newObject in userDefaults.set(newObject.rawValue, forKey: key) }
  }
  
  public var wrappedValue: Object {
    get { get() }
    set { set(newValue) }
  }
}

@propertyWrapper public struct OptionalUserDefault<Object> {
  
  private let get: () -> Object?
  private let set: (Object?) -> Void

  @available(*, deprecated, renamed: "init(userDefaults:key:default:)")
  public init(userDefaults: UserDefaults = .standard, key: String, defaultValue: @autoclosure @escaping () -> Object? = nil) {
    get = { userDefaults.object(forKey: key) as? Object ?? defaultValue() }
    set = { newObject in userDefaults.set(newObject, forKey: key) }
  }

  public init(userDefaults: UserDefaults = .standard, key: String, default defaultObject: @autoclosure @escaping () -> Object?) where Object: PropertyListObject {
    get = { userDefaults.object(forKey: key) as? Object ?? defaultObject() }
    set = { newObject in userDefaults.set(newObject, forKey: key) }
  }

  public init(userDefaults: UserDefaults = .standard, key: String, default defaultObject: @autoclosure @escaping () -> Object?) where Object: RawRepresentable, Object.RawValue: PropertyListObject {
    get = { (userDefaults.object(forKey: key) as? Object.RawValue).flatMap(Object.init(rawValue:)) ?? defaultObject() }
    set = { newObject in userDefaults.set(newObject?.rawValue, forKey: key) }
  }

  public var wrappedValue: Object? {
    get { get() }
    set { set(newValue) }
  }
}
#endif
