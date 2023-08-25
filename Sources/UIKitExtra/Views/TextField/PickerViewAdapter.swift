//
//  PickerViewAdapter.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

#if os(iOS)

import UIKit

open class PickerViewAdapter<Item>: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

  weak private var pickerView: UIPickerView?

  public let items: [Item]

  open var titleProvider: ((UIPickerView, Int, Int, Item) -> String)? {
    didSet {
      pickerView?.reloadAllComponents()
    }
  }
  open var attributedTitleProvider: ((UIPickerView, Int, Int, Item) -> NSAttributedString)? {
    didSet {
      pickerView?.reloadAllComponents()
    }
  }
  open var selectionHandler: ((UIPickerView, Int, Int, Item) -> Void)?

  public init(pickerView: UIPickerView, items: [Item]) {
    self.pickerView = pickerView
    self.items = items
    super.init()

    pickerView.dataSource = self
    pickerView.delegate = self
  }

  // MARK: UIPickerViewDataSource

  open func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    items.count
  }

  // MARK: UIPickerViewDelegate

  open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let item = items[row]
    return titleProvider?(pickerView, row, component, item) ?? String(describing: item)
  }

  open func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    attributedTitleProvider?(pickerView, row, component, items[row])
  }

  open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectionHandler?(pickerView, row, component, items[row])
  }
}

#endif
