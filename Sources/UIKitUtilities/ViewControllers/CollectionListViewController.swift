//
//  CollectionListViewController.swift
//
//  Created by Sereivoan Yong on 11/2/23.
//

import UIKit
import SwiftKit

@available(iOS 15.0, *)
open class CollectionListViewController: CollectionViewController {

  public typealias DataSource = UICollectionViewDiffableDataSource<CollectionSection, CollectionItem>

  public typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CollectionSection, CollectionItem>

  open private(set) var dataSource: DataSource!

  public let appearance: UICollectionLayoutListConfiguration.Appearance

  // MARK: Init / Deinit

  public init(appearance: UICollectionLayoutListConfiguration.Appearance, nibName: String? = nil, bundle: Bundle? = nil) {
    self.appearance = appearance
    super.init(nibName: nibName, bundle: bundle)
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
      guard let section = dataSource.sectionIdentifier(for: sectionIndex) else { fatalError()}
      return makeCollectionViewLayoutSection(at: sectionIndex, section: section, layoutEnvironment: layoutEnvironment)
    }, configuration: configuration)
    return layout
  }

  // MARK: LayoutConfiguration

  open func makeCollectionViewLayoutSection(at sectionIndex: Int, section: CollectionSection, layoutEnvironment: any NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let layoutSection: NSCollectionLayoutSection
    switch section.content {
    case .list(let header, let footer):
      var listConfiguration = UICollectionLayoutListConfiguration(appearance: appearance)
      listConfiguration.headerMode = header.mode
      listConfiguration.footerMode = footer.mode
      configure(&listConfiguration, forSectionAt: sectionIndex, layoutEnvironment: layoutEnvironment, section: section)
      layoutSection = .list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
    case .custom(let customLayoutSection):
      layoutSection = customLayoutSection
    }
    return layoutSection
  }

  open func configure(_ listConfiguration: inout UICollectionLayoutListConfiguration, forSectionAt sectionIndex: Int, layoutEnvironment: any NSCollectionLayoutEnvironment, section: CollectionSection) {
  }

  open override func collectionViewDidLoad() {
    super.collectionViewDidLoad()

    collectionView.register(UICollectionViewListCell.self)
    collectionView.register(UICollectionViewListCell.self, of: .sectionHeader)
    collectionView.register(UICollectionViewListCell.self, of: .sectionFooter)
    dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
      guard let item = dataSource.itemIdentifier(for: indexPath) else { fatalError() }
      return dequeueConfiguredCell(forItemAt: indexPath, item: item, in: collectionView)
    }
    dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
      let kind = UICollectionView.ElementKind(kind)
      return dequeueConfiguredSupplementaryView(of: kind, at: indexPath, in: collectionView)
    }
  }

  // MARK: Cell

  open func dequeueConfiguredCell(forItemAt indexPath: IndexPath, item: CollectionItem, in collectionView: UICollectionView) -> UICollectionViewListCell {
    let cell = collectionView.dequeue(UICollectionViewListCell.self, for: indexPath)
    configure(cell, forItemAt: indexPath, item: item)
    return cell
  }

  open func configure(_ cell: UICollectionViewListCell, forItemAt indexPath: IndexPath, item: CollectionItem) {
    var configuration = cell.defaultContentConfiguration()
    configuration.apply(item.content)
    cell.contentConfiguration = configuration
  }

  // MARK: Supplementary View

  open func dequeueConfiguredSupplementaryView(of kind: UICollectionView.ElementKind, at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionReusableView {
    switch kind {
    case .sectionHeader:
      guard let section = dataSource.sectionIdentifier(for: indexPath.section) else { fatalError() }
      let cell = collectionView.dequeue(UICollectionViewListCell.self, of: kind, for: indexPath)
      configureHeader(cell, forSectionAt: indexPath.section, section: section)
      return cell

    case .sectionFooter:
      guard let section = dataSource.sectionIdentifier(for: indexPath.section) else { fatalError() }
      let cell = collectionView.dequeue(UICollectionViewListCell.self, of: kind, for: indexPath)
      configureFooter(cell, forSectionAt: indexPath.section, section: section)
      return cell

    default:
      fatalError()
    }
  }

  // MARK: Header

  open func configureHeader(_ headerView: UICollectionReusableView, forSectionAt sectionIndex: Int, section: CollectionSection) {
    guard let cell = headerView as? UICollectionViewListCell, case .list(let header, _) = section.content, let content = header.content else { return }
    var configuration = cell.defaultContentConfiguration()
    configuration.apply(content)
    cell.contentConfiguration = configuration
  }

  // MARK: Footer

  open func configureFooter(_ footerView: UICollectionReusableView, forSectionAt sectionIndex: Int, section: CollectionSection) {
    guard let cell = footerView as? UICollectionViewListCell, case .list(_, let footer) = section.content, let content = footer.content else { return }
    var configuration = cell.defaultContentConfiguration()
    configuration.apply(content)
    cell.contentConfiguration = configuration
  }
}
