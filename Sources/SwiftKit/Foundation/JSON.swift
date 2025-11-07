//
//  JSON.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/7/25.
//

import Foundation

public enum JSON: Equatable {

  case string(NSString)
  case number(NSNumber)
  case bool(Bool)
  case array(NSArray)
  case dictionary(NSDictionary)
  case null

  public init?(with data: Data, options: JSONSerialization.ReadingOptions = []) throws {
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: options)
    self.init(jsonObject: jsonObject)
  }

  public init?(jsonObject: Any) {
    switch jsonObject {
    case let string as NSString:
      self = .string(string)

    case let number as NSNumber:
      // NSNumber can represent both Bool and Number — check carefully.
      if CFGetTypeID(number) != CFBooleanGetTypeID() {
        self = .number(number)
      } else {
        self = .bool(number.boolValue)
      }

    case let array as NSArray:
      self = .array(array)

    case let dictionary as NSDictionary:
      self = .dictionary(dictionary)

    case _ as NSNull:
      self = .null

    default:
      printIfDEBUG("Attempt to initialize JSON with unsupported type \(type(of: jsonObject))")
      return nil
    }
  }

  // MARK: Subscripts

  public subscript(index: Int) -> JSON? {
    if case .array(let array) = self {
      let jsonObject = array[index]
      return JSON(jsonObject: jsonObject)
    }
    return nil
  }

  public subscript(key: String) -> JSON? {
    if case .dictionary(let dictionary) = self {
      if let jsonObject = dictionary[key] {
        return JSON(jsonObject: jsonObject)
      }
    }
    return nil
  }

  // MARK: Optional

  public var string: String? {
    if case .string(let string) = self {
      return string as String
    }
    return nil
  }

  public var int: Int? {
    return number?.intValue
  }

  public var float: Float? {
    return number?.floatValue
  }

  public var double: Double? {
    return number?.doubleValue
  }

  public var number: NSNumber? {
    switch self {
    case .number(let number):
      return number
    case .bool(let bool):
      return bool as NSNumber
    default:
      return nil
    }
  }

  public var bool: Bool? {
    switch self {
    case .string(let string):
      switch string {
      case "0", "n", "N", "no", "NO", "false", "FALSE":
        return false
      case "1", "y", "Y", "yes", "YES", "true", "TRUE":
        return true
      default:
        return nil
      }
    case .number(let number):
      switch number {
      case 0:
        return false
      case 1:
        return true
      default:
        return nil
      }
    case .bool(let bool):
      return bool
    default:
      return nil
    }
  }

  public var array: [JSON]? {
    if case .array(let array) = self {
      return array.compactMap(JSON.init(jsonObject:))
    }
    return nil
  }

  public var dictionary: [String: JSON]? {
    if case .dictionary(let dictionary) = self {
      return dictionary.reduce(into: [:]) { result, pair in
        let key = pair.key as! String
        result[key] = JSON(jsonObject: pair.value)
      }
    }
    return nil
  }

  // MARK: Default

  public var stringValue: String {
    if case .string(let string) = self {
      return string as String
    }
    return ""
  }

  public var intValue: Int {
    return numberValue.intValue
  }

  public var floatValue: Float {
    return numberValue.floatValue
  }

  public var doubleValue: Double {
    return numberValue.doubleValue
  }

  public var numberValue: NSNumber {
    switch self {
    case .number(let number):
      return number
    case .bool(let bool):
      return bool as NSNumber
    default:
      return NSNumber()
    }
  }

  public var boolValue: Bool {
    switch self {
    case .string(let string):
      switch string {
      case "0", "n", "N", "no", "NO", "false", "FALSE":
        return false
      case "1", "y", "Y", "yes", "YES", "true", "TRUE":
        return true
      default:
        return false
      }
    case .number(let number):
      return number.boolValue
    case .bool(let bool):
      return bool
    default:
      return false
    }
  }

  public var arrayValue: [JSON] {
    if case .array(let array) = self {
      return array.compactMap(JSON.init(jsonObject:))
    }
    return []
  }

  public var dictionaryValue: [String: JSON] {
    if case .dictionary(let dictionary) = self {
      return dictionary.reduce(into: [:]) { result, pair in
        let key = pair.key as! String
        result[key] = .init(jsonObject: pair.value)
      }
    }
    return [:]
  }
}
