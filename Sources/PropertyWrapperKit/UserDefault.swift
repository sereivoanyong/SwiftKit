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
    get { return get() }
    nonmutating set { set(newValue) }
  }

  public init(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object
  ) where Object: PropertyListObject {
    get = { return defaults[key] as? Object ?? `default` }
    set = { defaults[key] = $0 }
  }

  public init(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object
  ) where Object: RawRepresentable, Object.RawValue: PropertyListObject {
    get = { return (defaults[key] as? Object.RawValue).flatMap(Object.init(rawValue:)) ?? `default` }
    set = { defaults[key] = $0.rawValue }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: PropertyListObject {
    get = { return defaults[key] as? Wrapped ?? `default` }
    set = { defaults[key] = $0 }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: RawRepresentable, Wrapped.RawValue: PropertyListObject {
    get = { return (defaults[key] as? Wrapped.RawValue).flatMap(Wrapped.init(rawValue:)) ?? `default` }
    set = { defaults[key] = $0?.rawValue }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    decoder: JSONDecoder = .init(),
    encoder: JSONEncoder = .init(),
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: Codable {
    get = { return (defaults[key] as? Data).flatMap { try? decoder.decode(Wrapped.self, from: $0) } ?? `default` }
    set = { defaults[key] = $0.flatMap { try? encoder.encode($0) } }
  }

  public init<Wrapped>(
    defaults: UserDefaults = .standard,
    key: String,
    decoder: PropertyListDecoder = .init(),
    encoder: PropertyListEncoder = .init(),
    default: Object = nil
  ) where Object == Wrapped?, Wrapped: Codable {
    get = { return (defaults[key] as? Data).flatMap { try? decoder.decode(Wrapped.self, from: $0) } ?? `default` }
    set = { defaults[key] = $0.flatMap { try? encoder.encode($0) } }
  }
}
#endif
