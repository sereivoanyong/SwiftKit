//
//  JSON.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/7/25.
//

import Foundation

public enum JSON: Hashable, @unchecked Sendable {

  case string(NSString)
  case number(NSNumber)
  case bool(Bool)
  case array(NSArray)
  case dictionary(NSDictionary)
  case null

  public var object: Any {
    switch self {
    case .string(let string):
      return string
    case .number(let number):
      return number
    case .bool(let bool):
      return bool
    case .array(let array):
      return array
    case .dictionary(let dictionary):
      return dictionary
    case .null:
      return NSNull()
    }
  }

  public init?(data: Data, options: JSONSerialization.ReadingOptions = []) throws {
    let object = try JSONSerialization.jsonObject(with: data, options: options)
    self.init(object)
  }

  public init?(_ object: Any) {
    switch object {
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
      printIfDEBUG("Attempt to initialize JSON with unsupported type \(type(of: object))")
      return nil
    }
  }

  // MARK: Subscripts

  public subscript(index: Int) -> JSON? {
    if case .array(let array) = self {
      let object = array[index]
      return JSON(object)
    }
    return nil
  }

  public subscript(key: String) -> JSON? {
    if case .dictionary(let dictionary) = self {
      if let object = dictionary[key] {
        return JSON(object)
      }
    }
    return nil
  }

  // MARK: Optional Swift Objects

  public var string: String? {
    return nsString as String?
  }

  public var int: Int? {
    return nsNumber?.intValue
  }

  public var uint: UInt? {
    return nsNumber?.uintValue
  }

  public var float: Float? {
    return nsNumber?.floatValue
  }

  public var double: Double? {
    return nsNumber?.doubleValue
  }

  public var decimal: Decimal? {
    return nsNumber?.decimalValue
  }

  public var bool: Bool? {
    if case .bool(let bool) = self {
      return bool
    }
    return nil
  }

  public var array: [Any]? {
    return nsArray as? [Any]
  }

  public var dictionary: [String: Any]? {
    return nsDictionary as? [String: Any]
  }

  // MARK: Optional Foundation Objects

  public var nsString: NSString? {
    if case .string(let string) = self {
      return string
    }
    return nil
  }

  public var nsNumber: NSNumber? {
    switch self {
    case .number(let number):
      return number
    case .bool(let bool):
      return NSNumber(value: bool)
    default:
      return nil
    }
  }

  public var nsArray: NSArray? {
    if case .array(let array) = self {
      return array
    }
    return nil
  }

  public var nsMutableArray: NSMutableArray? {
    return nsArray as? NSMutableArray
  }

  public var nsDictionary: NSDictionary? {
    if case .dictionary(let dictionary) = self {
      return dictionary
    }
    return nil
  }

  public var nsMutableDictionary: NSMutableDictionary? {
    return dictionary as? NSMutableDictionary
  }

  // MARK: Optional JSON Containers

  public var jsonArray: [JSON]? {
    if case .array(let array) = self {
      return array.compactMap(JSON.init)
    }
    return nil
  }

  public var jsonDictionary: [String: JSON]? {
    if case .dictionary(let dictionary) = self {
      return dictionary.reduce(into: [:]) { $0[$1.key as! String] = JSON($1.value) }
    }
    return nil
  }

  // MARK: Default Swift Objects

  public var stringValue: String {
    switch self {
    case .string(let string):
      return string as String
    case .number(let number):
      return number.stringValue
    case .bool(let bool):
      return String(bool)
    default:
      return ""
    }
  }

  public var intValue: Int {
    return nsNumberValue.intValue
  }

  public var uintValue: UInt {
    return nsNumberValue.uintValue
  }

  public var floatValue: Float {
    return nsNumberValue.floatValue
  }

  public var doubleValue: Double {
    return nsNumberValue.doubleValue
  }

  public var decimalValue: Decimal {
    return nsNumberValue.decimalValue
  }

  public var boolValue: Bool {
    switch self {
    case .string(let string):
      switch string.lowercased {
      case "true", "y", "t", "yes", "1":
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

  // MARK: Default Foundation Objects

  public var nsStringValue: NSString {
    switch self {
    case .string(let string):
      return string
    case .number(let number):
      return number.stringValue as NSString
    case .bool(let bool):
      return String(bool) as NSString
    default:
      return NSString()
    }
  }

  public var nsNumberValue: NSNumber {
    switch self {
    case .string(let string):
      let decimal = NSDecimalNumber(string: string as String)
      return decimal != .notANumber ? decimal : NSNumber()
    case .number(let number):
      return number
    case .bool(let bool):
      return NSNumber(value: bool)
    default:
      return NSNumber()
    }
  }

  public var nsArrayValue: NSArray {
    return nsArray ?? NSArray()
  }

  public var nsDictionaryValue: NSDictionary {
    return nsDictionary ?? NSDictionary()
  }

  // MARK: Default JSON Containers

  public var jsonArrayValue: [JSON] {
    return jsonArray ?? []
  }

  public var jsonDictionaryValue: [String: JSON] {
    return jsonDictionary ?? [:]
  }
}
