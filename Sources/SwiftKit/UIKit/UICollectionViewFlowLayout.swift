//
//  UICollectionViewFlowLayout.swift
//
//  Created by Sereivoan Yong on 1/27/20.
//

#if canImport(UIKit)
import UIKit

extension UICollectionViewFlowLayout {
  
  @inlinable public convenience init(scrollDirection: UICollectionView.ScrollDirection, minimumLineSpacing: CGFloat = 10, minimumInteritemSpacing: CGFloat = 10, itemSize: CGSize = CGSize(width: 50, height: 50), sectionInset: UIEdgeInsets = .zero) {
    self.init()
    self.scrollDirection = scrollDirection
    self.minimumLineSpacing = minimumLineSpacing
    self.minimumInteritemSpacing = minimumInteritemSpacing
    self.itemSize = itemSize
    self.sectionInset = sectionInset
  }
  
  @available(iOS 11.0, *)
  @inlinable public convenience init(scrollDirection: UICollectionView.ScrollDirection, minimumLineSpacing: CGFloat = 10, minimumInteritemSpacing: CGFloat = 10, itemSize: CGSize = CGSize(width: 50, height: 50), sectionInset: UIEdgeInsets = .zero, sectionInsetReference: SectionInsetReference) {
    self.init()
    self.scrollDirection = scrollDirection
    self.minimumLineSpacing = minimumLineSpacing
    self.minimumInteritemSpacing = minimumInteritemSpacing
    self.itemSize = itemSize
    self.sectionInset = sectionInset
    self.sectionInsetReference = sectionInsetReference
  }
}
#endif
