//
//  Dictionary.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

extension Dictionary {
  
  public func mapKeys<K>(to type: K.Type) -> [K: Value] where K: RawRepresentable, K.RawValue == Key {
    var dictionary: [K: Value] = [:]
    for (key, value) in self {
      if let newKey = K(rawValue: key) {
        dictionary[newKey] = value
      }
    }
    return dictionary
  }
  
  public func mapKeys<K>(_ transform: (Key) throws -> K) rethrows -> [K: Value] where K: Hashable {
    var dictionary: [K: Value] = [:]
    for (key, value) in self {
      let newKey = try transform(key)
      dictionary[newKey] = value
    }
    return dictionary
  }
  
  /// Accesses the element with the given key, or the specified update value then store,
  /// if the dictionary doesn't contain the given key.
  public subscript(key: Key, setIfNil setIfNil: @autoclosure () -> Value) -> Value {
    mutating get {
      let targetValue: Value
      if let value = self[key] {
        targetValue = value
      } else {
        targetValue = setIfNil()
        self[key] = targetValue
      }
      return targetValue
    }
  }
}

extension Dictionary where Key == String {
  
  public subscript(keyPath keyPath: String) -> Any? {
    var keys = keyPath.components(separatedBy: ".")
    let lastKey = keys.removeLast()
    guard !keys.isEmpty else {
      return self[lastKey]
    }
    var currentValue: [String: Any] = self
    for key in keys {
      if let value = currentValue[key] as? [String: Any] {
        currentValue = value
      } else {
        return nil
      }
    }
    return currentValue[lastKey]
  }
}
