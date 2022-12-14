//
//  Preference.swift
//
//  Created by Sereivoan Yong on 12/13/22.
//

import Foundation
import SwiftKit

@propertyWrapper
public struct Preference<Value, BackedValue: PropertyListObject> {

  private let from: (BackedValue?) -> Value
  private let to: (Value) -> BackedValue?

  public let key: String

  public let store: PreferenceStore

  public var wrappedValue: Value {
    get { return from(store[key] as? BackedValue) }
    nonmutating set { store[key] = to(newValue) }
  }

  public var projectedValue: BackedValue? {
    get { return store[key] as? BackedValue }
    nonmutating set { store[key] = newValue }
  }

  public init(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults
  ) where Value == BackedValue {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let value = backedValue {
        return value
      }
      let defaultValue = defaultValue()
      store[key] = defaultValue
      return defaultValue
    }
    self.to = { $0 }
  }

  public init(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value = nil,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults
  ) where Value == BackedValue? {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let value = backedValue {
        return value
      }
      if let defaultValue = defaultValue() {
        store[key] = defaultValue
        return defaultValue
      }
      return nil
    }
    self.to = { $0 }
  }

  public init(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults
  ) where Value: RawRepresentable<BackedValue> {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let rawValue = backedValue, let value = Value(rawValue: rawValue) {
        return value
      }
      let defaultValue = defaultValue()
      store[key] = defaultValue.rawValue
      return defaultValue
    }
    self.to = { $0.rawValue }
  }

  public init<R: RawRepresentable<BackedValue>>(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value = nil,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults
  ) where Value == R? {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let rawValue = backedValue, let value = R(rawValue: rawValue) {
        return value
      }
      if let defaultValue = defaultValue() {
        store[key] = defaultValue.rawValue
        return defaultValue
      }
      return nil
    }
    self.to = { $0?.rawValue }
  }

  public init(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults,
    decoder: TopLevelDecoder = .json(),
    encoder: TopLevelEncoder = .json()
  ) where Value: Codable, BackedValue == Data {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let data = backedValue, let value = try? decoder.decode(Value.self, from: data) {
        return value
      }
      let defaultValue = defaultValue()
      store[key] = try? encoder.encode(defaultValue)
      return defaultValue
    }
    self.to = { value in
      return try? encoder.encode(value)
    }
  }

  public init<C: Codable>(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value = nil,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults,
    decoder: TopLevelDecoder = .json(),
    encoder: TopLevelEncoder = .json()
  ) where Value == C?, BackedValue == Data {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let data = backedValue, let value = try? decoder.decode(C.self, from: data) {
        return value
      }
      if let defaultValue = defaultValue() {
        store[key] = try? encoder.encode(defaultValue)
        return defaultValue
      }
      return nil
    }
    self.to = { value in
      if let value {
        return try? encoder.encode(value)
      }
      return nil
    }
  }

  public init(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults,
    requiringSecureCoding: Bool
  ) where Value: NSObject & NSCoding, BackedValue == Data {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let data = backedValue, let value = try? NSKeyedUnarchiver.unarchivedObject(ofClass: Value.self, from: data) {
        return value
      }
      let defaultValue = defaultValue()
      store[key] = try? NSKeyedArchiver.archivedData(withRootObject: defaultValue, requiringSecureCoding: requiringSecureCoding)
      return defaultValue
    }
    self.to = { value in
      return try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: requiringSecureCoding)
    }
  }

  public init<C: NSObject & NSCoding>(
    wrappedValue defaultValue: @autoclosure @escaping () -> Value = nil,
    _ key: String,
    store: PreferenceStore = .standardUserDefaults,
    requiringSecureCoding: Bool
  ) where Value == C?, BackedValue == Data {
    self.key = key
    self.store = store
    self.from = { backedValue in
      if let data = backedValue, let value = try? NSKeyedUnarchiver.unarchivedObject(ofClass: C.self, from: data) {
        return value
      }
      if let defaultValue = defaultValue() {
        store[key] = try? NSKeyedArchiver.archivedData(withRootObject: defaultValue, requiringSecureCoding: requiringSecureCoding)
        return defaultValue
      }
      return nil
    }
    self.to = { value in
      if let value {
        return try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: requiringSecureCoding)
      }
      return nil
    }
  }
}
