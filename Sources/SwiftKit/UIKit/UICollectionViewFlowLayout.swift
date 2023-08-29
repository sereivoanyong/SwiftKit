//
//  UICollectionViewFlowLayout.swift
//
//  Created by Sereivoan Yong on 1/27/20.
//

import UIKit

extension UICollectionViewFlowLayout {

  @inlinable
  public convenience init(
    scrollDirection: UICollectionView.ScrollDirection,
    minimumLineSpacing: CGFloat = 10, 
    minimumInteritemSpacing: CGFloat = 10,
    itemSize: CGSize = CGSize(width: 50, height: 50),
    sectionInset: UIEdgeInsets = .zero,
    sectionInsetReference: SectionInsetReference = .fromContentInset
  ) {
    self.init()
    self.scrollDirection = scrollDirection
    self.minimumLineSpacing = minimumLineSpacing
    self.minimumInteritemSpacing = minimumInteritemSpacing
    self.itemSize = itemSize
    self.sectionInset = sectionInset
    self.sectionInsetReference = sectionInsetReference
  }
}
