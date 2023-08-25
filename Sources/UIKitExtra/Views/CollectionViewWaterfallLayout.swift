//
//  CollectionViewWaterfallLayout.swift
//
//  Created by Sereivoan Yong on 6/5/21.
//

import UIKit

public protocol CollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize

  func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, insetForSection section: Int) -> UIEdgeInsets

  func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, minimumInteritemSpacingForSection section: Int) -> CGFloat

  func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, numberOfColumnsInSection section: Int) -> Int

  func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, heightForHeaderInSection section: Int) -> CGFloat

  func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, heightForFooterInSection section: Int) -> CGFloat
}

extension CollectionViewDelegateWaterfallLayout {

  public func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, insetForSection section: Int) -> UIEdgeInsets {
    layout.sectionInset
  }

  public func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, minimumInteritemSpacingForSection section: Int) -> CGFloat {
    layout.minimumInteritemSpacing
  }

  public func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, numberOfColumnsInSection section: Int) -> Int {
    layout.numberOfColumns
  }

  public func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, heightForHeaderInSection section: Int) -> CGFloat {
    layout.headerHeight
  }

  public func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, heightForFooterInSection section: Int) -> CGFloat {
    layout.footerHeight
  }
}

extension CollectionViewWaterfallLayout {

  public enum ItemRenderDirection {

    case shortestFirst
    
    case leftToRight

    case rightToLeft
  }

  public enum SectionInsetReference {

    case fromContentInset

    case fromLayoutMargins

    @available(iOS 11.0, *)
    case fromSafeArea
  }
}

open class CollectionViewWaterfallLayout: UICollectionViewLayout {

  open var itemRenderDirection: ItemRenderDirection = .shortestFirst {
    didSet {
      invalidateLayout()
    }
  }

  open var sectionInsetReference: SectionInsetReference = .fromContentInset {
    didSet {
      invalidateLayout()
    }
  }

  open var sectionInset: UIEdgeInsets = .zero {
    didSet {
      invalidateLayout()
    }
  }

  open var minimumInteritemSpacing: CGFloat = 10 {
    didSet {
      invalidateLayout()
    }
  }

  open var numberOfColumns: Int = 2 {
    didSet {
      invalidateLayout()
    }
  }

  open var minimumColumnSpacing: CGFloat = 10 {
    didSet {
      invalidateLayout()
    }
  }

  open var headerHeight: CGFloat = 0 {
    didSet {
      invalidateLayout()
    }
  }

  open var footerHeight: CGFloat = 0 {
    didSet {
      invalidateLayout()
    }
  }

  private var columnHeights: [[CGFloat]] = []
  private var sectionItemAttributes: [[UICollectionViewLayoutAttributes]] = []
  private var allItemAttributes: [UICollectionViewLayoutAttributes] = []
  private var headersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
  private var footersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
  private var unionRects: [CGRect] = []
  private let unionSize: Int = 20

  private var collectionViewContentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets: UIEdgeInsets
    switch sectionInsetReference {
    case .fromContentInset:
      insets = collectionView.contentInset
    case .fromSafeArea:
      if #available(iOS 11.0, *) {
        insets = collectionView.safeAreaInsets
      } else {
        insets = .zero
      }
    case .fromLayoutMargins:
      insets = collectionView.layoutMargins
    }
    return collectionView.bounds.width - insets.left - insets.right
  }

  open override func prepare() {
    super.prepare()

    guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
      return
    }
    let delegate = collectionView.delegate as? CollectionViewDelegateWaterfallLayout
    headersAttributes = [:]
    footersAttributes = [:]
    unionRects = []
    allItemAttributes = []
    sectionItemAttributes = []
    columnHeights = []

    let contentWidth = collectionViewContentWidth
    var top: CGFloat = 0

    for section in 0 ..< collectionView.numberOfSections {
      // MARK: 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
      let sectionInset = delegate?.collectionView(collectionView, layout: self, insetForSection: section) ?? sectionInset
      let sectionWidth = contentWidth - sectionInset.left - sectionInset.right
      let numberOfColumns = delegate?.collectionView(collectionView, layout: self, numberOfColumnsInSection: section) ?? numberOfColumns
      let itemWidth = floor((sectionWidth - (CGFloat(numberOfColumns - 1) * minimumColumnSpacing)) / CGFloat(numberOfColumns))
      let minimumInteritemSpacing = delegate?.collectionView(collectionView, layout: self, minimumInteritemSpacingForSection: section) ?? minimumInteritemSpacing

      let supplementaryViewIndexPath = IndexPath(row: 0, section: section)

      // MARK: 2. Section header
      let heightHeader = delegate?.collectionView(collectionView, layout: self, heightForHeaderInSection: section) ?? headerHeight
      if heightHeader > 0 {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: supplementaryViewIndexPath)
        attributes.frame = CGRect(x: 0, y: top, width: collectionView.bounds.width, height: heightHeader)
        headersAttributes[section] = attributes
        allItemAttributes.append(attributes)

        top = attributes.frame.maxY
      }
      top += sectionInset.top
      columnHeights.append([CGFloat](repeating: top, count: numberOfColumns))

      // MARK: 3. Section items
      var itemAttributes: [UICollectionViewLayoutAttributes] = []

      // Item will be put into shortest column.
      for item in 0 ..< collectionView.numberOfItems(inSection: section) {
        let indexPath = IndexPath(item: item, section: section)

        let columnIndex: Int // shortest column
        switch itemRenderDirection {
        case .shortestFirst :
          columnIndex = columnHeights[section].enumerated().min(by: { $0.element < $1.element })!.offset
        case .leftToRight:
          columnIndex = item % numberOfColumns
        case .rightToLeft:
          columnIndex = (numberOfColumns - 1) - (item % numberOfColumns)
        }
        let xOffset = sectionInset.left + (itemWidth + minimumColumnSpacing) * CGFloat(columnIndex)

        let yOffset = columnHeights[section][columnIndex]
        var itemHeight: CGFloat = 0
        if let itemSize = delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath), itemSize.height > 0 {
          itemHeight = itemSize.height
          if itemSize.width > 0 {
            itemHeight = floor(itemHeight * itemWidth / itemSize.width)
          } // else use default item width based on other parameters
        }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
        itemAttributes.append(attributes)
        allItemAttributes.append(attributes)
        columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing
      }
      sectionItemAttributes.append(itemAttributes)

      // MARK: 4. Section footer
      let columnIndex = columnHeights[section].enumerated().max(by: { $0.element < $1.element })!.offset // longest column
      top = columnHeights[section][columnIndex] - minimumInteritemSpacing + sectionInset.bottom
      let footerHeight = delegate?.collectionView(collectionView, layout: self, heightForFooterInSection: section) ?? footerHeight
      if footerHeight > 0 {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: supplementaryViewIndexPath)
        attributes.frame = CGRect(x: 0, y: top, width: collectionView.bounds.width, height: footerHeight)
        footersAttributes[section] = attributes
        allItemAttributes.append(attributes)
        top = attributes.frame.maxY
      }

      columnHeights[section] = [CGFloat](repeating: top, count: numberOfColumns)
    }

    var index = 0
    let numberOfItems = allItemAttributes.count
    while index < numberOfItems {
      let rect1 = allItemAttributes[index].frame
      index = min(index + unionSize, numberOfItems) - 1
      let rect2 = allItemAttributes[index].frame
      unionRects.append(rect1.union(rect2))
      index += 1
    }
  }

  open override var collectionViewContentSize: CGSize {
    guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
      return .zero
    }

    var contentSize = collectionView.bounds.size
    contentSize.width = collectionViewContentWidth

    if let height = columnHeights.last?.first {
      contentSize.height = height
      return contentSize
    }
    return .zero
  }

  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if indexPath.section < sectionItemAttributes.count {
      let list = sectionItemAttributes[indexPath.section]
      if indexPath.item < list.count {
        return list[indexPath.item]
      }
    }
    return nil
  }

  open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
    switch elementKind {
    case UICollectionView.elementKindSectionHeader:
      return headersAttributes[indexPath.section]!
    case UICollectionView.elementKindSectionFooter:
      return footersAttributes[indexPath.section]!
    default:
      fatalError()
    }
  }

  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var begin = 0, end = unionRects.count

    if let i = unionRects.firstIndex(where: rect.intersects) {
      begin = i * unionSize
    }
    if let i = unionRects.lastIndex(where: rect.intersects) {
      end = min((i + 1) * unionSize, allItemAttributes.count)
    }
    return allItemAttributes[begin..<end].filter { rect.intersects($0.frame) }
  }

  open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    newBounds.width != collectionView?.bounds.width
  }
}
