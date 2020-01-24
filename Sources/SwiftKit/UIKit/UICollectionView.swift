//
//  UICollectionView.swift
//
//  Created by Sereivoan Yong on 8/2/17.
//

#if canImport(UIKit)
import UIKit

extension UICollectionView {
  
  @inlinable public convenience init(collectionViewLayout: UICollectionViewLayout) {
    self.init(frame: .zero, collectionViewLayout: collectionViewLayout)
  }
  
  /// Selects the items at the specified index paths.
  /// - Parameters:
  ///   - indexPaths: The index paths of the items to select. Specifying nil for this parameter clears the current selection.
  ///   - animated: Specify true to animate the change in the selection or false to make the change without animating it.
  final public func selectItems(at indexPaths: [IndexPath]?, animated: Bool) {
    if let indexPaths = indexPaths {
      for indexPath in indexPaths {
        selectItem(at: indexPath, animated: animated, scrollPosition: [])
      }
    } else {
      selectItem(at: nil, animated: animated, scrollPosition: [])
    }
  }
  
  final public func deselectSelectedItems(animated: Bool, transitionCoordinator: UIViewControllerTransitionCoordinator? = nil) {
    guard let selectedIndexPaths = indexPathsForSelectedItems, !selectedIndexPaths.isEmpty else {
      return
    }
    guard let transitionCoordinator = transitionCoordinator else {
      for indexPath in selectedIndexPaths {
        deselectItem(at: indexPath, animated: animated)
      }
      return
    }
    transitionCoordinator.animate(alongsideTransition: { [unowned self] context in
      for indexPath in selectedIndexPaths {
        self.deselectItem(at: indexPath, animated: context.isAnimated)
      }
    }, completion: { [unowned self] context in
      if context.isCancelled {
        for indexPath in selectedIndexPaths {
          self.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
      }
    })
  }
  
  // Supplementary View
  
  @inlinable final public func register<View>(_ viewClass: View.Type, identifier: String = String(describing: View.self), ofKind kind: String) where View: UICollectionReusableView {
    register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }
  
  @inlinable final public func unregister<View>(_ viewClass: View.Type, identifier: String = String(describing: View.self), ofKind kind: String) where View: UICollectionReusableView {
    register(nil as AnyClass?, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }
  
  @inlinable final public func dequeue<View>(_ viewClass: View.Type, identifier: String = String(describing: View.self), ofKind kind: String, for indexPath: IndexPath) -> View where View: UICollectionReusableView {
    return unsafeDowncast(dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath), to: View.self)
  }
  
  // Cell
  
  @inlinable final public func register<Cell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self)) where Cell: UICollectionViewCell {
    register(cellClass, forCellWithReuseIdentifier: identifier)
  }
  
  @inlinable final public func unregister<Cell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self)) where Cell: UICollectionViewCell {
    register(nil as AnyClass?, forCellWithReuseIdentifier: identifier)
  }
  
  @inlinable final public func dequeue<Cell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self), for indexPath: IndexPath) -> Cell where Cell: UICollectionViewCell {
    return unsafeDowncast(dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath), to: Cell.self)
  }
}
#endif
