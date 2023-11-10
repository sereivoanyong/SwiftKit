//
//  CollectionListViewController.swift
//
//  Created by Sereivoan Yong on 11/2/23.
//

import UIKit

@available(iOS 14.0, *)
open class CollectionListViewController: CollectionViewController {

  private var dataSource: UICollectionViewDiffableDataSource<CollectionListSection, CollectionListItem>!

  lazy public var supplementaryHeaderRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = .init(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] cell, elementKind, indexPath in
    let section = snapshot.sectionIdentifiers[indexPath.section]
    var configuration = cell.defaultContentConfiguration()
    section.content.apply(configuration: &configuration)
    cell.contentConfiguration = configuration
  }

  lazy public var supplementaryFooterRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = .init(elementKind: UICollectionView.elementKindSectionFooter) { [unowned self] cell, elementKind, indexPath in
    let section = snapshot.sectionIdentifiers[indexPath.section]
    var configuration = cell.defaultContentConfiguration()
    section.content.apply(configuration: &configuration)
    cell.contentConfiguration = configuration
  }

  lazy public var firstItemInSectionHeaderRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, CollectionListItem> = .init { [unowned self] cell, indexPath, item in
    let section = snapshot.sectionIdentifiers[indexPath.section]
    var configuration = cell.defaultContentConfiguration()
    section.content.apply(configuration: &configuration)
    cell.contentConfiguration = configuration
  }

  lazy public var itemRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, CollectionListItem> = .init { cell, indexPath, item in
    var configuration = cell.defaultContentConfiguration()
    item.content.apply(configuration: &configuration)
    cell.contentConfiguration = configuration
  }

  private var _snapshot: NSDiffableDataSourceSnapshot<CollectionListSection, CollectionListItem>!
  open var snapshot: NSDiffableDataSourceSnapshot<CollectionListSection, CollectionListItem>! {
    get { return _snapshot }
    set { apply(newValue) }
  }

  public let appearance: UICollectionLayoutListConfiguration.Appearance

  // MARK: Init / Deinit

  public init(appearance: UICollectionLayoutListConfiguration.Appearance, snapshot: NSDiffableDataSourceSnapshot<CollectionListSection, CollectionListItem>!) {
    self.appearance = appearance
    self._snapshot = snapshot
    super.init(nibName: nil, bundle: nil)
  }

  public override init(nibName: String?, bundle: Bundle?) {
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
    let layout = UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, layoutEnvironment in
      var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
      let section = snapshot.sectionIdentifiers[sectionIndex]
      configuration.headerMode = section.headerMode
      configuration.footerMode = section.footerMode
      updateLayoutSectionConfiguration(&configuration)
      let layoutSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
      return layoutSection
    }, configuration: configuration)
    return layout
  }

  open override func collectionViewDidLoad() {
    super.collectionViewDidLoad()

    dataSource = UICollectionViewDiffableDataSource<CollectionListSection, CollectionListItem>(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
      if indexPath.item == 0, let section = dataSource.findSectionIdentifier(for: indexPath.section), section.headerMode == .firstItemInSection {
        return collectionView.dequeueConfiguredReusableCell(using: firstItemInSectionHeaderRegistration, for: indexPath, item: item)
      }
      return collectionView.dequeueConfiguredReusableCell(using: itemRegistration, for: indexPath, item: item)
    }
    dataSource.supplementaryViewProvider = { [unowned self] collectionView, elementKind, indexPath in
      switch elementKind {
      case UICollectionView.elementKindSectionHeader:
        return collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryHeaderRegistration, for: indexPath)
      case UICollectionView.elementKindSectionFooter:
        return collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryFooterRegistration, for: indexPath)
      default:
        fatalError()
      }
    }
    
    var initialSnapshot = snapshot ?? .init()
    configureInitialSnapshot(&initialSnapshot)
    snapshot = initialSnapshot
  }

  open func updateLayoutSectionConfiguration(_ configuration: inout UICollectionLayoutListConfiguration) {

  }

  open func configureInitialSnapshot(_ snapshot: inout NSDiffableDataSourceSnapshot<CollectionListSection, CollectionListItem>) {
  }

  open func apply(_ snapshot: NSDiffableDataSourceSnapshot<CollectionListSection, CollectionListItem>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
    _snapshot = snapshot
    if isCollectionViewLoaded {
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
  }
}

@available(iOS 13.0, *)
extension UICollectionViewDiffableDataSource {

  func findSectionIdentifier(for index: Int) -> SectionIdentifierType? {
    if #available(iOS 15.0, *) {
      return sectionIdentifier(for: index)
    } else {
      return snapshot().sectionIdentifiers[index]
    }
  }
}
