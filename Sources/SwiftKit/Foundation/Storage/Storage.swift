//
//  Storage.swift
//
//  Created by Sereivoan Yong on 1/31/24.
//

#if canImport(Foundation)

import Foundation

@propertyWrapper
public struct Storage<Value, Store: DataStore> {

  public let key: String
  public let store: Store

  private let get: (Store, String) -> Value
  private let set: (Store, String, Value) -> Void

  public var wrappedValue: Value {
    get { return get(store, key) }
    nonmutating set { set(store, key, newValue) }
  }

  public var projectedValue: Storage<Value, Store> {
    return self
  }

  // MARK: Data

  public init(
    _ key: String,
    store: Store
  ) where Value == Data? {
    self.key = key
    self.store = store
    self.get = { store, key in
      return store.data(forKey: key)
    }
    self.set = { store, key, newValue in
      store.set(newValue, forKey: key)
    }
  }

  public init(
    _ key: String,
    default: Data,
    store: Store
  ) where Value == Data {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let data = store.data(forKey: key) {
        return data
      }
      store.set(`default`, forKey: key)
      return `default`
    }
    self.set = { store, key, newValue in
      store.set(newValue, forKey: key)
    }
  }

  // MARK: Data Transforming

  public init<T>(
    _ key: String,
    store: Store = UserDefaults.standard,
    transforming: StorageDataTransforming<T>
  ) where Value == T? {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let data = store.data(forKey: key) {
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
          let data = try transforming.data(from: value)
          store.set(data, forKey: key)
        } catch {
          printIfDEBUG(error)
          store.set(nil, forKey: key)
        }
      } else {
        store.set(nil, forKey: key)
      }
    }
  }

  public init(
    _ key: String,
    default: Value,
    store: Store = UserDefaults.standard,
    transforming: StorageDataTransforming<Value>
  ) {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let data = store.data(forKey: key) {
        do {
          if let value = try transforming.value(from: data) {
            return value
          }
        } catch {
          printIfDEBUG(error)
        }
      }
      do {
        let data = try transforming.data(from: `default`)
        store.set(data, forKey: key)
      } catch {
        printIfDEBUG(error)
      }
      return `default`
    }
    self.set = { store, key, value in
      do {
        let data = try transforming.data(from: value)
        store.set(data, forKey: key)
      } catch {
        printIfDEBUG(error)
        store.set(nil, forKey: key)
      }
    }
  }
}

extension Storage where Store: PropertyListStore {

  // MARK: PropertyListObject

  public init<T: PropertyListObject>(
    _ key: String,
    store: Store = UserDefaults.standard
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
        store.set(value, forKey: key)
      } else {
        store.set(nil, forKey: key)
      }
    }
  }

  public init(
    _ key: String,
    default: Value,
    store: Store = UserDefaults.standard
  ) where Value: PropertyListObject {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let value = store[key] as? Value {
        return value
      }
      store.set(`default`, forKey: key)
      return `default`
    }
    self.set = { store, key, value in
      store.set(value, forKey: key)
    }
  }

  // MARK: RawRepresentable where RawValue: PropertyListObject

  public init<T: RawRepresentable>(
    _ key: String,
    store: Store = UserDefaults.standard
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
        store.set(value.rawValue, forKey: key)
      } else {
        store.set(nil, forKey: key)
      }
    }
  }

  public init(
    _ key: String,
    default: Value,
    store: Store = UserDefaults.standard
  ) where Value: RawRepresentable, Value.RawValue: PropertyListObject {
    self.key = key
    self.store = store
    self.get = { store, key in
      if let rawValue = store[key] as? Value.RawValue, let value = Value(rawValue: rawValue) {
        return value
      }
      store.set(`default`.rawValue, forKey: key)
      return `default`
    }
    self.set = { store, key, value in
      store.set(value.rawValue, forKey: key)
    }
  }
}

#endif
