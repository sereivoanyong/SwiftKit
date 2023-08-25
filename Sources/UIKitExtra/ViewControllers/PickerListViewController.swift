//
//  PickerListViewController.swift
//
//  Created by Sereivoan Yong on 3/10/22.
//

import UIKit

// TODO: section/item modeling rework, search support & deselection support

@available(iOS 14.0, *)
open class PickerListViewController<Item>: CollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  public struct Section {

    public let items: [Item]
  }

  public enum Behavior {

    /// Exit via navigation `backButtonItem` or pop gesture
    /// - `saveAndShowHandler` is invoked on selection.
    case pushWithSaveAndShowChangeOnSelection(saveAndShowHandler: (Item) -> Void) // appearance, font, etc.

    /// Exit via navigation `backButtonItem` or pop gesture
    /// - `saveHandler` is invoked on selection.
    case pushWithSaveChangeOnSelectionThenPop(saveHandler: (Item) -> Void)

    /// Exit via `doneButtonItem`
    /// - `saveAndShowHandler` is invoked on selection.
    case presentWithSaveAndShowChangeOnSelection(saveAndShowHandler: (Item) -> Void)

    /// Exit via `cancelButtonItem` and save/dismiss via `doneButtonItem`
    /// - `saveHandler` is invoked on `doneButtonItem` tapped
    /// - `showHandler` is invoked on selection
    /// - `restoreHandler` is invoked on `cancelButtonItem` tapped.
    case presentWithShowChangeOnSelection(saveHandler: (Item) -> Void, showHandler: (Item) -> Void, restoreHandler: () -> Void)

    /// Exit via `cancelButtonItem`
    /// - `saveHandler` is invoked on selection.
    case presentWithSaveChangeOnSelectionThenDismiss(saveHandler: (Item) -> Void)
  }

  private let equalityProvider: (Item, Item) -> Bool

  public let behavior: Behavior

  open var sections: [Section] {
    didSet {
      if isCollectionViewLoaded {
        collectionView.reloadData()
      }
    }
  }

  open var selectedItem: Item?

  open var contentProvider: (Item) -> UIListContentConfiguration = { item in
    var content = UIListContentConfiguration.cell()
    content.text = "\(item)"
    return content
  } {
    didSet {
      if isCollectionViewLoaded {
        collectionView.reloadData()
      }
    }
  }

  public convenience init(items: [Item], behavior: Behavior) where Item: Identifiable {
    self.init(equalityProvider: { $0.id == $1.id }, items: items, behavior: behavior)
  }

  public convenience init(items: [Item], behavior: Behavior) where Item: Equatable {
    self.init(equalityProvider: ==, items: items, behavior: behavior)
  }

  private init(equalityProvider: @escaping (Item, Item) -> Bool, items: [Item], behavior: Behavior) {
    self.equalityProvider = equalityProvider
    self.sections = [.init(items: items)]
    self.behavior = behavior
    super.init(nibName: nil, bundle: nil)

    navigationItem.largeTitleDisplayMode = .never
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("\(#function) has not been implemented")
  }

  open override func makeCollectionViewLayout() -> UICollectionViewLayout {
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.backgroundColor = .clear
    return UICollectionViewCompositionalLayout.list(using: configuration)
  }

  open override func collectionViewDidLoad() {
    super.collectionViewDidLoad()

    collectionView.register(PickerListCell.self, forCellWithReuseIdentifier: "\(PickerListCell.self)")

    if let selectedItem = selectedItem {
      for (sectionIndex, section) in sections.enumerated() {
        for (itemIndex, item) in section.items.enumerated() where equalityProvider(item, selectedItem) {
          DispatchQueue.main.async { [unowned collectionView] in
            collectionView.selectItem(at: IndexPath(item: itemIndex, section: sectionIndex), animated: false, scrollPosition: .centeredVertically)
          }
          return
        }
      }
    }
  }

  open override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let navigationController = navigationController, navigationController.isBeingPresented {
      if navigationController.viewControllers.first === self {
        if #available(iOS 15.0, *), navigationController.sheetPresentationController != nil {
          switch behavior {
          case .pushWithSaveAndShowChangeOnSelection:
            break
          case .pushWithSaveChangeOnSelectionThenPop:
            break
          case .presentWithSaveAndShowChangeOnSelection:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(done(_:)))
          case .presentWithShowChangeOnSelection:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:))) // to save then dismiss
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:))) // to exit
          case .presentWithSaveChangeOnSelectionThenDismiss:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel(_:)))
          }
        } else {
          switch behavior {
          case .pushWithSaveAndShowChangeOnSelection:
            break
          case .pushWithSaveChangeOnSelectionThenPop:
            break
          case .presentWithSaveAndShowChangeOnSelection:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:))) // to exit
          case .presentWithShowChangeOnSelection:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:))) // to save then dismiss
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:))) // to exit
          case .presentWithSaveChangeOnSelectionThenDismiss:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:))) // to exit
          }
        }
      }
    }
  }

  @objc open func done(_ sender: Any?) {
    switch behavior {
    case .pushWithSaveAndShowChangeOnSelection:
      fatalError()
    case .pushWithSaveChangeOnSelectionThenPop:
      fatalError()
    case .presentWithSaveAndShowChangeOnSelection:
      dismiss(animated: true, completion: nil)
    case .presentWithShowChangeOnSelection(let saveHandler, _, _):
      guard let selectedItem = selectedItem else {
        return
      }
      saveHandler(selectedItem)
      dismiss(animated: true, completion: nil)
    case .presentWithSaveChangeOnSelectionThenDismiss:
      fatalError()
    }
  }

  @objc open func cancel(_ sender: UIBarButtonItem) {
    switch behavior {
    case .pushWithSaveAndShowChangeOnSelection:
      fatalError()
    case .pushWithSaveChangeOnSelectionThenPop:
      fatalError()
    case .presentWithSaveAndShowChangeOnSelection:
      fatalError()
    case .presentWithShowChangeOnSelection(_, _, let restoreHandler):
      restoreHandler()
      dismiss(animated: true, completion: nil)
    case .presentWithSaveChangeOnSelectionThenDismiss:
      dismiss(animated: true, completion: nil)
    }
  }

  @inlinable
  func item(at indexPath: IndexPath) -> Item {
    return sections[indexPath.section].items[indexPath.item]
  }

  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sections[section].items.count
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PickerListCell.self)", for: indexPath) as! PickerListCell
    let item = item(at: indexPath)
    cell.contentConfiguration = contentProvider(item)
    var background = UIBackgroundConfiguration.listPlainCell()
    background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
      return .clear
    }
    cell.backgroundConfiguration = background
    return cell
  }

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let newSelectedItem = item(at: indexPath)
    selectedItem = newSelectedItem

    switch behavior {
    case .pushWithSaveAndShowChangeOnSelection(let saveAndShowHandler):
      saveAndShowHandler(newSelectedItem)
    case .pushWithSaveChangeOnSelectionThenPop(let saveHandler):
      saveHandler(newSelectedItem)
      navigationController?.popViewController(animated: true)
    case .presentWithSaveAndShowChangeOnSelection(let saveAndShowHandler):
      saveAndShowHandler(newSelectedItem)
    case .presentWithShowChangeOnSelection(_, let showHandler, _):
      showHandler(newSelectedItem)
    case .presentWithSaveChangeOnSelectionThenDismiss(let saveHandler):
      saveHandler(newSelectedItem)
      dismiss(animated: true, completion: nil)
    }
  }
}

@available(iOS 14.0, *)
final private class PickerListCell: UICollectionViewListCell {

  override var isSelected: Bool {
    didSet {
      accessories = isSelected ? [.checkmark()] : []
    }
  }
}
