//
//  FilterView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/15/25.
//

import UIKit
import SwiftKit
import Combine

@available(iOS 15.0, *)
open class FilterView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  private var itemCancellables: Set<AnyCancellable> = []

  open var items: [any FilterItem] {
    didSet {
      observe()
      reloadData()
    }
  }

  open var verticalSectionInsets: YAxisEdges<CGFloat> = .zero

  @Published open private(set) var predicates: [NSPredicate?] = []

  public init(frame: CGRect = .zero, items: [any FilterItem] = []) {
    self.items = items
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 8
    flowLayout.scrollDirection = .horizontal
    super.init(frame: frame, collectionViewLayout: flowLayout)

    alwaysBounceHorizontal = true
    alwaysBounceVertical = false
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    contentInsetAdjustmentBehavior = .never
    backgroundColor = .clear
    clipsToBounds = false
    dataSource = self
    delegate = self

    commonInit()
    reloadData()
  }

  public required init?(coder: NSCoder) {
    self.items = []
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    register(UICollectionViewCell.self)
    observe()
  }

  private func observe() {
    itemCancellables.removeAll()
    predicates = [NSPredicate?](repeating: nil, count: items.count)
    for (index, item) in items.enumerated() {
      let item = item as! any FilterItemInternal
      item.predicatePublisher.sink { [unowned self] predicate in
        predicates[index] = predicate
      }.store(in: &itemCancellables)
    }
  }

  open override func layoutMarginsDidChange() {
    super.layoutMarginsDidChange()

    collectionViewLayout.invalidateLayout()
  }

  // MARK: UICollectionViewDataSource

  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(UICollectionViewCell.self, for: indexPath)
    let item = items[indexPath.item]
    cell.contentConfiguration = FilterItemContentConfiguration(item: item as! any FilterItemInternal)
    cell.backgroundColor = .clear
    return cell
  }

  // MARK: UICollectionViewDelegate

  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }

  // MARK: UICollectionViewDelegateFlowLayout

  open func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let item = items[indexPath.item]
    let size = FilterItemView.size(for: item as! any FilterItemInternal, traitCollection: collectionView.traitCollection)
    return CGSize(width: size.width, height: collectionView.bounds.height - verticalSectionInsets.vertical)
  }

  open func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return collectionView.layoutMargins.withVertical(verticalSectionInsets)
  }
}
