//
//  CollectionListViewController.swift
//
//  Created by Sereivoan Yong on 11/2/23.
//

import UIKit

@available(iOS 13.0, *)
extension UICollectionViewDiffableDataSource {

  @inlinable
  func _sectionIdentifier(for index: Int) -> SectionIdentifierType? {
    if #available(iOS 15.0, *) {
      return sectionIdentifier(for: index)
    } else {
      return snapshot().sectionIdentifiers[index]
    }
  }
}

@available(iOS 14.0, *)
open class CollectionListViewController: CollectionViewController {

  public typealias DataSource = UICollectionViewDiffableDataSource<CollectionListSection, CollectionListItem>

  public typealias Snapshot = NSDiffableDataSourceSnapshot<CollectionListSection, CollectionListItem>

  lazy public private(set) var supplementaryHeaderRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = .init(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] cell, elementKind, indexPath in
    if let section = dataSource._sectionIdentifier(for: indexPath.section), let content = section.header.content {
      var configuration = cell.defaultContentConfiguration()
      content.apply(to: &configuration)
      cell.contentConfiguration = configuration
    } else {
      cell.contentConfiguration = nil
    }
  }

  lazy public private(set) var supplementaryFooterRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = .init(elementKind: UICollectionView.elementKindSectionFooter) { [unowned self] cell, elementKind, indexPath in
    if let section = dataSource._sectionIdentifier(for: indexPath.section), let content = section.footer.content {
      var configuration = cell.defaultContentConfiguration()
      content.apply(to: &configuration)
      cell.contentConfiguration = configuration
    } else {
      cell.contentConfiguration = nil
    }
  }

  lazy public private(set) var itemRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, CollectionListItem> = .init { cell, indexPath, item in
    var configuration = cell.defaultContentConfiguration()
    item.content.apply(to: &configuration)
    cell.contentConfiguration = configuration
  }

  open private(set) var dataSource: DataSource!

  public let appearance: UICollectionLayoutListConfiguration.Appearance

  // MARK: Init / Deinit

  public init(appearance: UICollectionLayoutListConfiguration.Appearance) {
    self.appearance = appearance
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
      guard let sectionIdentifier = dataSource._sectionIdentifier(for: sectionIndex) else { fatalError()}
      var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
      switch sectionIdentifier.header {
      case .none:
        configuration.headerMode = .none
      case .supplementary:
        configuration.headerMode = .supplementary
      case .firstItemInSection:
        configuration.headerMode = .firstItemInSection
      }
      switch sectionIdentifier.footer {
      case .none:
        configuration.headerMode = .none
      case .supplementary:
        configuration.footerMode = .supplementary
      }
      configureListConfiguration(&configuration, for: sectionIdentifier)
      let layoutSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
      return layoutSection
    }, configuration: configuration)
    return layout
  }

  open override func collectionViewDidLoad() {
    super.collectionViewDidLoad()

    _ = itemRegistration
    dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
      return collectionView.dequeueConfiguredReusableCell(using: itemRegistration, for: indexPath, item: item)
    }
    _ = supplementaryHeaderRegistration
    _ = supplementaryFooterRegistration
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
  }

  open func configureListConfiguration(_ configuration: inout UICollectionLayoutListConfiguration, for sectionIdentifier: CollectionListSection) {
  }
}
