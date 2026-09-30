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
public enum FilterItemConfiguration {

  case toggle(buttonHandler: ((UIButton) -> Void)?)
  case selection(
    buttonHandler: ((UIButton) -> Void)?,
    valuesProvider: (@escaping ([Any]) -> Void) -> Void,
    actionConfigurationProvider: (Any) -> UIAction.Configuration,
    isEqual: (Any, Any) -> Bool
  )

  public static func selection<Value: Equatable>(
    buttonHandler: ((UIButton) -> Void)?,
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration
  ) -> Self {
    return selection(
      buttonHandler: buttonHandler,
      valuesProvider: { completion in valuesProvider(completion) },
      actionConfigurationProvider: { value in actionConfigurationProvider(value as! Value) },
      isEqual: { a, b in a as! Value == b as! Value }
    )
  }
}

@available(iOS 15.0, *)
public protocol FilterItem: ObservableObject {

  var id: String { get }

  var title: String { get }

  var currentTitle: String { get }

  var configuration: FilterItemConfiguration { get }

  var predicate: NSPredicate? { get }

  var predicatePublisher: Published<NSPredicate?>.Publisher { get }

  var isSelected: Bool { get }
}

// MARK: - ToggleFilterItem

final public class ToggleFilterItemGroup {

  public internal(set) var filterItems: [any ToggleFilterItemProtocol] = []

  public init() {
  }
}

@available(iOS 15.0, *)
public protocol ToggleFilterItemProtocol: FilterItem {

  var isSelected: Bool { get set }

  var isSelectedPublisher: Published<Bool>.Publisher { get }

  var group: ToggleFilterItemGroup? { get }
}

@available(iOS 15.0, *)
open class ToggleFilterItem<Value: Equatable>: FilterItem, ToggleFilterItemProtocol {

  public let id: String

  public let title: String

  public var currentTitle: String {
    return title
  }

  @Published open var isSelected: Bool = false {
    didSet {
      predicate = isSelected ? predicateProvider() : nil
    }
  }

  public var isSelectedPublisher: Published<Bool>.Publisher {
    return $isSelected
  }

  public let value: Value

  public let configuration: FilterItemConfiguration

  public let predicateProvider: () -> NSPredicate

  @Published public private(set) var predicate: NSPredicate?

  public var predicatePublisher: Published<NSPredicate?>.Publisher {
    return $predicate
  }

  open private(set) var group: ToggleFilterItemGroup?

  public init(
    id: String = UUID().uuidString,
    title: String,
    value: Value,
    buttonHandler: ((UIButton) -> Void)? = nil,
    isSelected: Bool = false,
    predicateProvider: @escaping () -> NSPredicate, // Called when selected
    group: ToggleFilterItemGroup? = nil
  ) {
    self.id = id
    self.title = title
    self.value = value
    self.configuration = .toggle(buttonHandler: buttonHandler)
    self.isSelected = isSelected
    self.predicateProvider = predicateProvider
    self.predicate = isSelected ? predicateProvider() : nil
    self.group = group
    group?.filterItems.append(self)
  }
}

// MARK: - SelectionFilterItem

@available(iOS 15.0, *)
public protocol SelectionFilterItem: FilterItem {

  var selectionType: FilterItemSelectionType { get }
  var canDeselect: Bool { get }
}

public enum FilterItemSelectionType {

  case single
  case multi
}

// MARK: - SelectionFilterItem

@available(iOS 15.0, *)
protocol SingleSelectionFilterItemProtocol: SelectionFilterItem {

  var anyDefaultValue: Any? { get }

  var anySelectedValue: Any? { get set }
}

@available(iOS 15.0, *)
open class SingleSelectionFilterItem<Value: Equatable>: FilterItem, SingleSelectionFilterItemProtocol {

  public let selectionType: FilterItemSelectionType = .single

  public let id: String

  public let title: String

  public var currentTitle: String {
    if let selectedValue {
      return titleProvider(selectedValue)
    }
    return title
  }

  /// Any selected value equal to this vaue is not considered as selection for button.
  /// In most cases, this is nil.
  public let defaultValue: Value?

  var anyDefaultValue: Any? {
    return defaultValue
  }

  open var selectedValue: Value? {
    didSet {
      predicate = selectedValue.map(predicateProvider)
    }
  }

  var anySelectedValue: Any? {
    get { return selectedValue }
    set { selectedValue = newValue as! Value? }
  }

  public var isSelected: Bool {
    return selectedValue != defaultValue
  }

  public let titleProvider: (Value) -> String

  public let configuration: FilterItemConfiguration

  public let predicateProvider: (Value) -> NSPredicate

  @Published public private(set) var predicate: NSPredicate?

  public var predicatePublisher: Published<NSPredicate?>.Publisher {
    return $predicate
  }

  public let canDeselect: Bool

  public init(
    id: String = UUID().uuidString,
    title: String,
    defaultValue: Value? = nil,
    selectedValue: Value? = nil,
    buttonHandler: ((UIButton) -> Void)? = nil,
    titleProvider: @escaping (Value) -> String,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration,
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    predicateProvider: @escaping (Value) -> NSPredicate,
    canDeselect: Bool = true
  ) {
    self.id = id
    self.title = title
    self.defaultValue = defaultValue
    self.selectedValue = selectedValue
    self.titleProvider = titleProvider
    self.configuration = .selection(buttonHandler: buttonHandler, valuesProvider: valuesProvider, actionConfigurationProvider: actionConfigurationProvider)
    self.predicateProvider = predicateProvider
    self.predicate = selectedValue.map(predicateProvider)
    self.canDeselect = canDeselect
  }
}

// MARK: - MultiSelectionFilterItem

@available(iOS 15.0, *)
public protocol MultiSelectionFilterItemProtocol: SelectionFilterItem {

  var anySelectedValues: [Any] { get set }
}

@available(iOS 15.0, *)
open class MultiSelectionFilterItem<Value: Equatable>: FilterItem, MultiSelectionFilterItemProtocol {

  public let selectionType: FilterItemSelectionType = .multi

  public let id: String

  public let title: String

  public var currentTitle: String {
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

  public var isSelected: Bool {
    return !selectedValues.isEmpty
  }

  public let titleProvider: ([Value]) -> String

  public let configuration: FilterItemConfiguration

  public let predicateProvider: ([Value]) -> NSPredicate

  @Published public private(set) var predicate: NSPredicate?

  public var predicatePublisher: Published<NSPredicate?>.Publisher {
    return $predicate
  }

  public let canDeselect: Bool

  public init(
    id: String = UUID().uuidString,
    title: String,
    selectedValues: [Value] = [],
    buttonHandler: ((UIButton) -> Void)? = nil,
    titleProvider: @escaping ([Value]) -> String,
    actionConfigurationProvider: @escaping (Value) -> UIAction.Configuration,
    valuesProvider: @escaping (@escaping ([Value]) -> Void) -> Void,
    predicateProvider: @escaping ([Value]) -> NSPredicate, // Selected values is guaranteed to be non-empty
    canDeselect: Bool = true
  ) {
    self.id = id
    self.title = title
    self.selectedValues = selectedValues
    self.titleProvider = titleProvider
    self.configuration = .selection(buttonHandler: buttonHandler, valuesProvider: valuesProvider, actionConfigurationProvider: actionConfigurationProvider)
    self.predicateProvider = predicateProvider
    self.predicate = selectedValues.nonEmpty.map(predicateProvider)
    self.canDeselect = canDeselect
  }
}
