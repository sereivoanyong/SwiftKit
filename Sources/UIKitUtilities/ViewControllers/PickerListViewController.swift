//
//  PickerListViewController.swift
//
//  Created by Sereivoan Yong on 3/10/22.
//

import UIKit

// TODO: section/item modeling rework, search support & deselection support

/// If being presented modally, the picker dismisses itself on selection. Title should be "Select Item".
/// If being pushed (not as root), user will need to pop manually. Title should be "Item".
@available(iOS 14.0, *)
open class PickerListViewController<Item: Equatable>: CollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  public struct Section {

    public let items: [Item]
  }

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

  open var handler: (PickerListViewController<Item>, Item) -> Void

  // MARK: Init

  public init(items: [Item], handler: @escaping (PickerListViewController<Item>, Item) -> Void) {
    self.sections = [.init(items: items)]
    self.handler = handler
    super.init(nibName: nil, bundle: nil)

    navigationItem.largeTitleDisplayMode = .never
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Collection View Lifecycle

  open override func makeCollectionViewLayout() -> UICollectionViewLayout {
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.backgroundColor = .clear
    return UICollectionViewCompositionalLayout.list(using: configuration)
  }

  open override func collectionViewDidLoad() {
    super.collectionViewDidLoad()

    collectionView.register(PickerListCell.self, forCellWithReuseIdentifier: "\(PickerListCell.self)")
  }

  // MARK: View Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    if let selectedItem {
      for (sectionIndex, section) in sections.enumerated() {
        for (itemIndex, item) in section.items.enumerated() where item == selectedItem {
          DispatchQueue.main.async { [unowned self] in
            collectionView.selectItem(at: IndexPath(item: itemIndex, section: sectionIndex), animated: false, scrollPosition: .centeredVertically)
          }
          return
        }
      }
    }
  }

  open override func willMove(toParent parent: UIViewController?) {
    super.willMove(toParent: parent)

    if let navigationController = parent as? UINavigationController {
      if navigationController.viewControllers.first === self {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss(_:)))
      }
    }
  }

  // MARK: Data

  @inlinable
  func item(at indexPath: IndexPath) -> Item {
    return sections[indexPath.section].items[indexPath.item]
  }

  // MARK: UICollectionViewDataSource

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

  // MARK: UICollectionViewDelegate

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let newSelectedItem = item(at: indexPath)
    selectedItem = newSelectedItem

    handler(self, newSelectedItem)
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
