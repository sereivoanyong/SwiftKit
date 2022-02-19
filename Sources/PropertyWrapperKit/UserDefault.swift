//
//  UserDefault.swift
//
//  Created by Sereivoan Yong on 11/25/19.
//

#if canImport(Foundation)
import Foundation
import SwiftKit

/*
 enum UserPreferences {
   
   @UserDefault(key: "IsFirstOpen", default: true)
   static var isFirstOpen: Bool
 }
 */

@propertyWrapper
public struct UserDefault<Object> {

  private let get: () -> Object
  private let set: (Object) -> Void

  public var wrappedValue: Object {
    get { get() }
    nonmutating set { set(newValue) }
  }

  public init(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object
  ) where Object: PropertyListObject {
    get = {
      defaults.object(forKey: key) as? Object ?? `default`
    }
    set = {
      newObject in defaults.set(newObject, forKey: key)
    }
  }

  public init(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object
  ) where Object: RawRepresentable, Object.RawValue: PropertyListObject {
    get = {
      (defaults.object(forKey: key) as? Object.RawValue).flatMap(Object.init(rawValue:)) ?? `default`
    }
    set = {
      newObject in defaults.set(newObject.rawValue, forKey: key)
    }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: PropertyListObject {
    get = {
      defaults.object(forKey: key) as? Wrapped ?? `default`
    }
    set = {
      newObject in defaults.set(newObject, forKey: key)
    }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: RawRepresentable, Wrapped.RawValue: PropertyListObject {
    get = {
      (defaults.object(forKey: key) as? Wrapped.RawValue).flatMap(Wrapped.init(rawValue:)) ?? `default`
    }
    set = {
      newObject in defaults.set(newObject?.rawValue, forKey: key)
    }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    decoder: JSONDecoder = .init(),
    encoder: JSONEncoder = .init(),
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: Codable {
    get = {
      defaults.data(forKey: key).flatMap { try? decoder.decode(Wrapped.self, from: $0) } ?? `default`
    }
    set = { newObject in
      defaults.set(newObject.flatMap { try? encoder.encode($0) }, forKey: key)
    }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    decoder: PropertyListDecoder = .init(),
    encoder: PropertyListEncoder = .init(),
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: Codable {
    get = {
      defaults.data(forKey: key).flatMap { try? decoder.decode(Wrapped.self, from: $0) } ?? `default`
    }
    set = { newObject in
      defaults.set(newObject.flatMap { try? encoder.encode($0) }, forKey: key)
    }
  }
}
#endif
