//
//  Storage.swift
//
//  Created by Sereivoan Yong on 1/31/24.
//

#if canImport(Foundation)

import Foundation

@propertyWrapper
public struct Storage<Value> {

  public let key: String
  public let store: Store

  private let get: (Store, String) -> Value
  private let set: (Store, String, Value) -> Void

  public var wrappedValue: Value {
    get { return get(store, key) }
    nonmutating set { set(store, key, newValue) }
  }

  public var projectedValue: Storage<Value> {
    return self
  }

  // MARK: PropertyListObject

  public init<T: PropertyListObject>(
    _ key: String,
    store: Store = .standardDefaults
  ) where Value == T? {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let value = store[key] as? T {
        return value
      }
      return nil
    }
    self.set = { store, key, value in
      if let value {
        store[key] = value
      } else {
        store[key] = nil
      }
    }
  }

  public init(
    _ key: String,
    default: Value,
    store: Store = .standardDefaults
  ) where Value: PropertyListObject {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let value = store[key] as? Value {
        return value
      }
      return `default`
    }
    self.set = { store, key, value in
      store[key] = value
    }
  }

  // MARK: RawRepresentable where RawValue: PropertyListObject

  public init<T: RawRepresentable>(
    _ key: String,
    store: Store = .standardDefaults
  ) where T.RawValue: PropertyListObject, Value == T? {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let rawValue = store[key] as? T.RawValue, let value = T(rawValue: rawValue) {
        return value
      }
      return nil
    }
    self.set = { store, key, value in
      if let value {
        store[key] = value.rawValue
      } else {
        store[key] = nil
      }
    }
  }

  public init(
    _ key: String,
    default: Value,
    store: Store = .standardDefaults
  ) where Value: RawRepresentable, Value.RawValue: PropertyListObject {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let rawValue = store[key] as? Value.RawValue, let value = Value(rawValue: rawValue) {
        return value
      }
      return `default`
    }
    self.set = { store, key, value in
      store[key] = value.rawValue
    }
  }

  // MARK: DataTransforming

  public init<Transforming: StorageDataTransforming>(
    _ key: String,
    store: Store = .standardDefaults,
    transforming: Transforming
  ) where Value == Transforming.T? {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let data = store[key] as? Data {
        do {
          return try transforming.value(from: data)
        } catch {
          printIfDEBUG(error)
        }
      }
      return nil
    }
    self.set = { store, key, value in
      if let value {
        do {
          store[key] = try transforming.data(from: value)
        } catch {
          printIfDEBUG(error)
          store[key] = nil
        }
      } else {
        store[key] = nil
      }
    }
  }

  public init<Transforming: StorageDataTransforming>(
    _ key: String,
    default: Value,
    store: Store = .standardDefaults,
    transforming: Transforming
  ) where Transforming.T == Value {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let data = store[key] as? Data {
        do {
          if let value = try transforming.value(from: data) {
            return value
          }
        } catch {
          printIfDEBUG(error)
        }
      }
      return `default`
    }
    self.set = { store, key, value in
      do {
        store[key] = try transforming.data(from: value)
      } catch {
        printIfDEBUG(error)
        store[key] = nil
      }
    }
  }
}

#endif
