//
//  UserDefault.swift
//
//  Created by Sereivoan Yong on 11/25/19.
//

import Foundation
import SwiftKit

/*
 enum UserPreferences {
   
   @UserDefault(key: "IsFirstOpen", default: true)
   static var isFirstOpen: Bool
 }
 */

extension UserDefault {

  public struct Coder {

    public let decoder: TopLevelDecoder
    public let encoder: TopLevelEncoder

    public static func json(decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) -> Self {
      return .init(decoder: decoder, encoder: encoder)
    }

    public static func propertyList(decoder: PropertyListDecoder = .init(), encoder: PropertyListEncoder = .init()) -> Self {
      return .init(decoder: decoder, encoder: encoder)
    }
  }
}

@propertyWrapper
public struct UserDefault<T> {

  public let defaults: UserDefaults
  public let key: String

  private let get: (UserDefaults, String, (UserDefaults, String, T) -> Void) -> T
  private let set: (UserDefaults, String, T) -> Void

  public var wrappedValue: T {
    get { return get(defaults, key, set) }
    nonmutating set { set(defaults, key, newValue) }
  }

  public init(
    defaults: UserDefaults = .standard,
    key: String,
    default: T
  ) where T: PropertyListObject {
    self.defaults = defaults
    self.key = key
    self.get = { defaults, key, set in
      if let value = defaults[key] as T? {
        return value
      }
      set(defaults, key, `default`)
      return `default`
    }
    self.set = { defaults, key, newValue in
      defaults[key] = newValue
    }
  }

  public init<RawValue: PropertyListObject>(
    defaults: UserDefaults = .standard,
    key: String,
    default: T
  ) where T: RawRepresentable<RawValue> {
    self.defaults = defaults
    self.key = key
    self.get = { defaults, key, set in
      if let rawValue = defaults[key] as T.RawValue?, let value = T(rawValue: rawValue) {
        return value
      }
      set(defaults, key, `default`)
      return `default`
    }
    self.set = { defaults, key, newValue in
      defaults[key] = newValue.rawValue
    }
  }

  public init<Wrapped: PropertyListObject>(
    defaults: UserDefaults = .standard,
    key: String,
    default: T = nil
  ) where T == Wrapped? {
    self.defaults = defaults
    self.key = key
    self.get = { defaults, key, set in
      if let value = defaults[key] as Wrapped? {
        return value
      }
      set(defaults, key, `default`)
      return `default`
    }
    self.set = { defaults, key, newValue in
      defaults[key] = newValue
    }
  }

  public init<Wrapped: RawRepresentable>(
    defaults: UserDefaults = .standard,
    key: String,
    default: T = nil
  ) where T == Wrapped?, Wrapped.RawValue: PropertyListObject {
    self.defaults = defaults
    self.key = key
    self.get = { defaults, key, set in
      if let rawValue = defaults[key] as Wrapped.RawValue?, let value = Wrapped(rawValue: rawValue) {
        return value
      }
      set(defaults, key, `default`)
      return `default`
    }
    self.set = { defaults, key, newValue in
      defaults[key] = newValue?.rawValue
    }
  }

  public init<Wrapped: Codable>(
    defaults: UserDefaults = .standard,
    key: String,
    coder: Coder,
    default: T = nil
  ) where T == Wrapped? {
    self.defaults = defaults
    self.key = key
    self.get = { defaults, key, set in
      if let data = defaults[key] as Data?, let value = try? coder.decoder.decode(Wrapped.self, from: data) {
        return value
      }
      set(defaults, key, `default`)
      return `default`
    }
    self.set = { defaults, key, newValue in
      defaults[key] = newValue.flatMap { try? coder.encoder.encode($0) }
    }
  }

  public init<Wrapped: NSObject & NSCoding>(
    defaults: UserDefaults = .standard,
    key: String,
    default: T = nil,
    requiringSecureCoding: Bool
  ) where T == Wrapped? {
    self.defaults = defaults
    self.key = key
    self.get = { defaults, key, set in
      if let data = defaults[key] as Data?, let object = try? NSKeyedUnarchiver.unarchivedObject(ofClass: Wrapped.self, from: data) {
        return object
      }
      set(defaults, key, `default`)
      return `default`
    }
    self.set = { defaults, key, newObject in
      defaults[key] = newObject.flatMap { try? NSKeyedArchiver.archivedData(withRootObject: $0, requiringSecureCoding: requiringSecureCoding) }
    }
  }
}
