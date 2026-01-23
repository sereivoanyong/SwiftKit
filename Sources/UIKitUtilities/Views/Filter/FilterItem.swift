//
//  FilterItem.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/15/25.
//

import UIKit
import SwiftKit
import Combine

@available(iOS 15.0, *)
public enum FilterItemSelection {

  case toggleSelection
  case selection(
    valuesProvider: (@escaping ([Any]) -> Void) -> Void,
    actionConfigurationProvider: (Any) -> UIAction.Configuration,
    isCollection: Bool,
    isEqual: (Any, Any) -> Bool
  )

  static func value<Value: Equatable>(
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration
  ) -> Self {
    return selection(
      valuesProvider: { completion in valuesProvider(completion) },
      actionConfigurationProvider: { value in actionConfigurationProvider(value as! Value) },
      isCollection: false,
      isEqual: { a, b in a as! Value == b as! Value }
    )
  }

  static func values<Value: Equatable>(
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration
  ) -> Self {
    return selection(
      valuesProvider: { completion in valuesProvider(completion) },
      actionConfigurationProvider: { value in actionConfigurationProvider(value as! Value) },
      isCollection: true,
      isEqual: { a, b in a as! Value == b as! Value }
    )
  }
}

@available(iOS 15.0, *)
public protocol FilterItem: ObservableObject {

  var id: String { get }

  var title: String { get }

  var valueSelection: FilterItemSelection { get }

  var predicate: NSPredicate? { get }

  var isSelected: Bool { get }
}

@available(iOS 15.0, *)
protocol FilterItemInternal: FilterItem {

  /// For size calculation
  var currentTitle: String { get }

  var predicateSubject: PassthroughSubject<NSPredicate?, Never> { get }
}

// MARK: - [Value,Collection]ToggleFilterItem

@available(iOS 15.0, *)
public protocol ToggleFilterItem: FilterItem {

  var isSelected: Bool { get set }
}

/// Value property against value
@available(iOS 15.0, *)
open class ValueToggleFilterItem<Object: AnyObject, Value: Equatable>: ToggleFilterItem, FilterItemInternal {

  public let id: String

  public let title: String

  public var currentTitle: String {
    return title
  }

  open var isSelected: Bool = false {
    didSet {
      predicate = isSelected ? predicateProvider(value) : nil
    }
  }

  public let value: Value

  public let valueSelection: FilterItemSelection = .toggleSelection

  public let predicateProvider: (Value) -> NSPredicate

  public private(set) var predicate: NSPredicate? {
    didSet {
      predicateSubject.send(predicate)
    }
  }

  public let predicateSubject = PassthroughSubject<NSPredicate?, Never>()

  public init(
    id: String = UUID().uuidString,
    title: String,
    value: Value,
    isSelected: Bool = false,
    predicateProvider: @escaping (Value) -> NSPredicate // Called when selected
  ) {
    self.id = id
    self.title = title
    self.value = value
    self.isSelected = isSelected
    self.predicateProvider = predicateProvider
    self.predicate = isSelected ? predicateProvider(value) : nil
  }
}

@available(iOS 15.0, *)
open class CollectionToggleFilterItem<Object: AnyObject, Value: Equatable>: ToggleFilterItem, FilterItemInternal {

  public let id: String

  public let title: String

  var currentTitle: String {
    return title
  }

  open var isSelected: Bool = false {
    didSet {
      predicate = isSelected ? predicateProvider(values) : nil
    }
  }

  public let values: [Value]

  public let valueSelection: FilterItemSelection = .toggleSelection

  public let predicateProvider: ([Value]) -> NSPredicate

  public private(set) var predicate: NSPredicate? {
    didSet {
      predicateSubject.send(predicate)
    }
  }

  public let predicateSubject = PassthroughSubject<NSPredicate?, Never>()

  public init(
    id: String = UUID().uuidString,
    title: String,
    values: [Value],
    isSelected: Bool = false,
    predicateProvider: @escaping ([Value]) -> NSPredicate // Called when selected
  ) {
    self.id = id
    self.title = title
    self.values = values
    self.isSelected = false
    self.predicateProvider = predicateProvider
    self.predicate = isSelected ? predicateProvider(values) : nil
  }
}

// MARK: - [Value,Collection]ValueFilterItem

@available(iOS 15.0, *)
public protocol ValueFilterItem: FilterItem {

  var anySelectedValue: Any? { get set }
}

@available(iOS 15.0, *)
extension ValueFilterItem {

  public var isSelected: Bool {
    return anySelectedValue != nil
  }
}

@available(iOS 15.0, *)
open class ValueValueFilterItem<Object: AnyObject, Value: Equatable>: ValueFilterItem, FilterItemInternal {

  public let id: String

  public let title: String

  var currentTitle: String {
    if let selectedValue {
      return titleProvider(selectedValue)
    }
    return title
  }

  open var selectedValue: Value? {
    didSet {
      predicate = selectedValue.map(predicateProvider)
    }
  }

  public var anySelectedValue: Any? {
    get { return selectedValue }
    set { selectedValue = newValue as! Value? }
  }

  public let titleProvider: (Value) -> String

  public let valueSelection: FilterItemSelection

  public let predicateProvider: (Value) -> NSPredicate

  public private(set) var predicate: NSPredicate? {
    didSet {
      predicateSubject.send(predicate)
    }
  }

  public let predicateSubject = PassthroughSubject<NSPredicate?, Never>()

  public init(
    id: String = UUID().uuidString,
    title: String,
    selectedValue: Value? = nil,
    titleProvider: @escaping (Value) -> String,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration,
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    predicateProvider: @escaping (Value) -> NSPredicate
  ) {
    self.id = id
    self.title = title
    self.selectedValue = selectedValue
    self.titleProvider = titleProvider
    self.valueSelection = .value(valuesProvider: valuesProvider, actionConfigurationProvider: actionConfigurationProvider)
    self.predicateProvider = predicateProvider
    self.predicate = selectedValue.map(predicateProvider)
  }
}

@available(iOS 15.0, *)
open class CollectionValueFilterItem<Object: AnyObject, Value: Equatable>: ValueFilterItem, FilterItemInternal {

  public let id: String

  public let title: String

  var currentTitle: String {
    if let selectedValue {
      return titleProvider(selectedValue)
    }
    return title
  }

  open var selectedValue: Value? {
    didSet {
      predicate = selectedValue.map(predicateProvider)
    }
  }

  public var anySelectedValue: Any? {
    get { return selectedValue }
    set { selectedValue = newValue as! Value? }
  }

  public let titleProvider: (Value) -> String

  public let valueSelection: FilterItemSelection

  public let predicateProvider: (Value) -> NSPredicate

  public private(set) var predicate: NSPredicate? {
    didSet {
      predicateSubject.send(predicate)
    }
  }

  public let predicateSubject = PassthroughSubject<NSPredicate?, Never>()

  public init(
    id: String = UUID().uuidString,
    title: String,
    selectedValue: Value? = nil,
    titleProvider: @escaping (Value) -> String,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration,
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    predicateProvider: @escaping (Value) -> NSPredicate // Return nil if empty
  ) {
    self.id = id
    self.title = title
    self.selectedValue = selectedValue
    self.titleProvider = titleProvider
    self.valueSelection = .value(valuesProvider: valuesProvider, actionConfigurationProvider: actionConfigurationProvider)
    self.predicateProvider = predicateProvider
    self.predicate = selectedValue.map(predicateProvider)
  }
}

// MARK: - [Value,Collection]ValuesFilterItem

@available(iOS 15.0, *)
public protocol ValuesFilterItem: FilterItem {

  var anySelectedValues: [Any] { get set }
}

@available(iOS 15.0, *)
extension ValuesFilterItem {

  public var isSelected: Bool {
    return !anySelectedValues.isEmpty
  }
}

@available(iOS 15.0, *)
open class ValueValuesFilterItem<Object: AnyObject, Value: Equatable>: ValuesFilterItem, FilterItemInternal {

  public let id: String

  public let title: String

  var currentTitle: String {
    if !selectedValues.isEmpty {
      return titleProvider(selectedValues)
    }
    return title
  }

  open var selectedValues: [Value] {
    didSet {
      predicate = selectedValues.nonEmpty.map(predicateProvider)
    }
  }

  public var anySelectedValues: [Any] {
    get { return selectedValues }
    set { selectedValues = newValue as! [Value] }
  }

  public let titleProvider: ([Value]) -> String

  public let valueSelection: FilterItemSelection

  public let predicateProvider: ([Value]) -> NSPredicate

  public private(set) var predicate: NSPredicate? {
    didSet {
      predicateSubject.send(predicate)
    }
  }

  public let predicateSubject = PassthroughSubject<NSPredicate?, Never>()

  public init(
    id: String = UUID().uuidString,
    title: String,
    selectedValues: [Value] = [],
    titleProvider: @escaping ([Value]) -> String,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration,
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    predicateProvider: @escaping ([Value]) -> NSPredicate // Selected values is guaranteed to be non-empty
  ) {
    self.id = id
    self.title = title
    self.selectedValues = selectedValues
    self.titleProvider = titleProvider
    self.valueSelection = .values(valuesProvider: valuesProvider, actionConfigurationProvider: actionConfigurationProvider)
    self.predicateProvider = predicateProvider
    self.predicate = selectedValues.nonEmpty.map(predicateProvider)
  }
}

@available(iOS 15.0, *)
open class CollectionValuesFilterItem<Object: AnyObject, Value: Equatable>: ValuesFilterItem, FilterItemInternal {

  public let id: String

  public let title: String

  var currentTitle: String {
    if !selectedValues.isEmpty {
      return titleProvider(selectedValues)
    }
    return title
  }

  @Published open var selectedValues: [Value] {
    didSet {
      predicate = selectedValues.nonEmpty.map(predicateProvider)
    }
  }

  public var anySelectedValues: [Any] {
    get { return selectedValues }
    set { selectedValues = newValue as! [Value] }
  }

  public let titleProvider: ([Value]) -> String

  public let valueSelection: FilterItemSelection

  public let predicateProvider: ([Value]) -> NSPredicate

  public private(set) var predicate: NSPredicate? {
    didSet {
      predicateSubject.send(predicate)
    }
  }

  public let predicateSubject = PassthroughSubject<NSPredicate?, Never>()

  public init(
    id: String = UUID().uuidString,
    title: String,
    selectedValues: [Value] = [],
    titleProvider: @escaping ([Value]) -> String,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration,
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    predicateProvider: @escaping ([Value]) -> NSPredicate // Selected values is guaranteed to be non-empty
  ) {
    self.id = id
    self.title = title
    self.selectedValues = selectedValues
    self.titleProvider = titleProvider
    self.valueSelection = .values(valuesProvider: valuesProvider, actionConfigurationProvider: actionConfigurationProvider)
    self.predicateProvider = predicateProvider
    self.predicate = selectedValues.nonEmpty.map(predicateProvider)
  }
}
