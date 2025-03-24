//
//  ModernCollectionViewController.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/9/24.
//

import UIKit

@available(iOS 15.0, *)
open class ModernCollectionViewController<SectionIdentifier: Hashable, ItemIdentifier: Hashable>: CollectionViewController {

  public typealias DataSource = UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>

  public typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>

  public typealias DataSourceSectionSnapshot = NSDiffableDataSourceSectionSnapshot<ItemIdentifier>

  open private(set) var dataSourceIfSet: DataSource!

  @inlinable
  open var dataSource: DataSource! {
    return dataSourceIfSet
  }

  public let appearance: UICollectionLayoutListConfiguration.Appearance

  // MARK: Init / Deinit

  public init(appearance: UICollectionLayoutListConfiguration.Appearance, nibName: String? = nil, bundle: Bundle? = nil) {
    self.appearance = appearance
    super.init(nibName: nibName, bundle: bundle)
  }

  public override init(nibName: String? = nil, bundle: Bundle? = nil) {
    self.appearance = .plain
    super.init(nibName: nibName, bundle: bundle)
  }

  public required init?(coder: NSCoder) {
    self.appearance = .plain
    super.init(coder: coder)
  }

  // MARK: Collection View Lifecycle

  open override func makeCollectionViewLayout() -> UICollectionViewLayout {
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] index, layoutEnvironment in
      guard let sectionIdentifier = dataSource.sectionIdentifier(for: index) else { return nil }
      var listConfiguration = UICollectionLayoutListConfiguration(appearance: appearance)
      configureListConfiguration(&listConfiguration, at: index, for: sectionIdentifier)
      return NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
    }, configuration: configuration)
  }

  open func configureListConfiguration(_ listConfiguration: inout UICollectionLayoutListConfiguration, at index: Int, for sectionIdentifier: SectionIdentifier) {
    if let listSection = listSection(at: index, for: sectionIdentifier) {
      listConfiguration.headerMode = listSection.headerConfiguration() == nil ? .none : .supplementary
      listConfiguration.footerMode = listSection.footerConfiguration() == nil ? .none : .supplementary
    }
  }

  open func makeDataSource() -> UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier> {
    let dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, itemIdentifier in
      return cell(in: collectionView, at: indexPath, for: itemIdentifier)
    }
    dataSource.supplementaryViewProvider = { [unowned self, unowned dataSource] collectionView, kind, indexPath in
      guard let sectionIdentifier = dataSource.sectionIdentifier(for: indexPath.section) else { return nil }
      let kind = UICollectionView.ElementKind(kind)
      return supplementaryView(in: collectionView, of: kind, at: indexPath, for: sectionIdentifier)
    }
    return dataSource
  }

  open override func collectionViewDidLoad() {
    super.collectionViewDidLoad()

    collectionView.register(CollectionViewListCell.self)
    collectionView.register(CollectionViewListCell.self, of: .sectionHeader)
    collectionView.register(CollectionViewListCell.self, of: .sectionFooter)
    dataSourceIfSet = makeDataSource()
  }

  // MARK: View Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    reloadData(animatingDifferences: false)
  }

  // MARK: Data

  open func reloadData(animatingDifferences: Bool) {
  }

  open func listSection(at index: Int, for identifier: SectionIdentifier) -> ListSection<SectionIdentifier>? {
    return nil
  }

  open func listItem(at indexPath: IndexPath, for identifier: ItemIdentifier) -> ListItem<ItemIdentifier> {
    fatalError()
  }

  open func cell(in collectionView: UICollectionView, at indexPath: IndexPath, for itemIdentifier: ItemIdentifier) -> UICollectionViewCell {
    let cell = collectionView.dequeue(CollectionViewListCell.self, for: indexPath)
    let listItem = listItem(at: indexPath, for: itemIdentifier)
    cell.apply(listItem.configuration())
    return cell
  }

  open func supplementaryView(in collectionView: UICollectionView, of kind: UICollectionView.ElementKind, at indexPath: IndexPath, for sectionIdentifier: SectionIdentifier) -> UICollectionReusableView {
    switch kind {
    case .sectionHeader:
      guard let listSection = listSection(at: indexPath.section, for: sectionIdentifier) else { fatalError() }
      let cell = collectionView.dequeue(CollectionViewListCell.self, of: kind, for: indexPath)
      cell.apply(listSection.headerConfiguration())
      return cell

    case .sectionFooter:
      let cell = collectionView.dequeue(CollectionViewListCell.self, of: kind, for: indexPath)
      guard let listSection = listSection(at: indexPath.section, for: sectionIdentifier) else { fatalError() }
      cell.apply(listSection.footerConfiguration())
      return cell

    default:
      fatalError()
    }
  }
}
