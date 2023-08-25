//
//  PickerTextField.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

#if os(iOS)

import UIKit

open class PickerTextField<Item: Equatable>: DropdownTextField {

  public typealias AdapterProvider = (UIPickerView, [Item]) -> PickerViewAdapter<Item>

  public static var selectedItemDidChangeNotification: Notification.Name {
    Notification.Name("PickerTextField<\(Item.self)>SelectedItemDidChangeNotification")
  }

  public enum Source {

    case pickerView(UIPickerView, adapter: PickerViewAdapter<Item>)
    case presentation(handler: (Item?, @escaping (Item?) -> Void) -> UIViewController)
  }

  private weak var presentingViewController: UIViewController?

  private var inputViewWrapperView: UIView!

  open override var inputView: UIView? {
    get { super.inputView ?? inputViewWrapperView }
    set { super.inputView = newValue }
  }

  open private(set) var source: Source?

  private var _selectedItem: Item?
  open var selectedItem: Item? {
    get { _selectedItem }
    set { select(newValue, updateSource: true, sendValueChangedActions: false) }
  }

  open var textProvider: (Item) -> String = String.init(describing:) {
    didSet {
      setNeedsTextProviderUpdate()
    }
  }

  open var itemUpdateHandler: ((PickerTextField<Item>) -> Void)? {
    didSet {
      itemUpdateHandler?(self)
    }
  }

  private func select(_ selectedItem: Item?, updateSource: Bool, sendValueChangedActions: Bool) {
    willChangeValue(forKey: "selectedItem")
    if selectedItem != _selectedItem {
      _selectedItem = selectedItem
      text = selectedItem.map(textProvider)
      itemUpdateHandler?(self)
      if updateSource, let source = source {
        switch source {
        case .pickerView(let pickerView, let adapter):
          if let selectedItem = selectedItem, let row = adapter.items.firstIndex(of: selectedItem) {
            pickerView.selectRow(row, inComponent: 0, animated: false)
          }

        case .presentation:
          break
        }
      }
      if sendValueChangedActions {
        sendActions(for: .valueChanged)
        NotificationCenter.default.post(name: Self.selectedItemDidChangeNotification, object: self)
      }
    }
    didChangeValue(forKey: "selectedItem")
  }

  open func setNeedsTextProviderUpdate() {
    text = selectedItem.map(textProvider)
    if case .pickerView(let pickerView, _) = source {
      pickerView.reloadAllComponents()
    }
  }

  open func setSourcePickerView(_ pickerView: UIPickerView? = nil, adapterProvider: AdapterProvider? = nil, configurationHandler: ((PickerViewAdapter<Item>) -> Void)? = nil) where Item: CaseIterable, Item.AllCases == [Item] {
    setSourcePickerView(pickerView, items: Item.allCases, configurationHandler: configurationHandler)
  }

  open func setSourcePickerView(_ pickerView: UIPickerView? = nil, adapterProvider: AdapterProvider? = nil, items: [Item], configurationHandler: ((PickerViewAdapter<Item>) -> Void)? = nil) {
    let pickerView = pickerView ?? UIPickerView()
    let adapter = adapterProvider?(pickerView, items) ?? PickerViewAdapter<Item>(pickerView: pickerView, items: items)
    adapter.titleProvider = { [unowned self] _, _, _, item in
      self.textProvider(item)
    }
    configurationHandler?(adapter)
    assert(adapter.selectionHandler == nil, "`selectionHandler` is managed by the textField")
    adapter.selectionHandler = { [unowned self] _, _, _, item in
      self.select(item, updateSource: false, sendValueChangedActions: true)
    }
    source = .pickerView(pickerView, adapter: adapter)
    inputViewWrapperView = Self.wrapperView(inputView: pickerView)
  }

  open func setSourcePresentation(handler: @escaping (Item?, @escaping (Item?) -> Void) -> UIViewController) {
    source = .presentation(handler: handler)
  }

  open override var canBecomeFirstResponder: Bool {
    // `UIKit` will call `textFieldShouldBeginEditing(_:)` here
    let canBecomeFirstResponder = super.canBecomeFirstResponder
    if canBecomeFirstResponder, case .presentation = source {
      return false
    }
    return canBecomeFirstResponder
  }

  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    let become = super.becomeFirstResponder()
    if let source = source {
      switch source {
      case .pickerView(let pickerView, let adapter):
        if let selectedItem = selectedItem {
          if let row = adapter.items.firstIndex(of: selectedItem), pickerView.selectedRow(inComponent: 0) != row {
            DispatchQueue.main.async {
              pickerView.selectRow(row, inComponent: 0, animated: false)
            }
          }
        } else {
          if let firstItem = adapter.items.first {
            select(firstItem, updateSource: true, sendValueChangedActions: true)
          }
        }

      case .presentation(let handler):
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        if presentingViewController == nil {
          presentingViewController = handler(self.selectedItem, { [unowned self] item in
            self.select(item, updateSource: false, sendValueChangedActions: true)
          })
        }
      }
    }
    return become
  }

  open override func clear() {
    selectedItem = nil
  }
}

extension PickerTextField {

  public convenience init(selectedItem: Item? = nil, placeholder: String? = nil, font: UIFont? = nil, textAlignment: NSTextAlignment = .natural, textColor: UIColor? = nil) {
    self.init()
    self.font = font
    self.textAlignment = textAlignment
      // On iOS 13, default text color is `.label`. When Set to nil, it becomes `.black`
    if #available(iOS 13.0, *) {
      self.textColor = textColor ?? .label
    } else {
      self.textColor = textColor
    }
    self.placeholder = placeholder
    self.selectedItem = selectedItem
  }
}

#endif
