//
//  PickerContentViewController.swift
//
//  Created by Sereivoan Yong on 1/5/25.
//

import UIKit

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol PickerViewController<Item>: UIViewController {

  associatedtype Item: Identifiable

  var selectedItemIdentifiers: [Item.ID] { get set }

  var allowsMultipleSelection: Bool { get set }

  var finishPickingHandler: ((any PickerViewController<Item>, [Item]) -> Void)? { get set }

  var cancelHandler: ((any PickerViewController<Item>) -> Void)? { get set }
}
