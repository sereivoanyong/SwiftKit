//
//  UICollectionView.swift
//
//  Created by Sereivoan Yong on 8/2/17.
//

import UIKit

extension UICollectionView {

  public typealias CellProvider<Item> = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?

  public static let elementKindSectionBackground = "UICollectionElementKindSectionBackground"

  @inlinable
  public convenience init(collectionViewLayout: UICollectionViewLayout) {
    self.init(frame: .zero, collectionViewLayout: collectionViewLayout)
  }

  /// Selects the items at the specified index paths.
  /// - Parameters:
  ///   - indexPaths: The index paths of the items to select. Specifying nil for this parameter clears the current selection.
  ///   - animated: Specify true to animate the change in the selection or false to make the change without animating it.
  public func selectItems(at indexPaths: [IndexPath]?, animated: Bool) {
    if let indexPaths {
      for indexPath in indexPaths {
        selectItem(at: indexPath, animated: animated, scrollPosition: [])
      }
    } else {
      selectItem(at: nil, animated: animated, scrollPosition: [])
    }
  }

  public func deselectSelectedItems(animated: Bool, transitionCoordinator: UIViewControllerTransitionCoordinator? = nil) {
    guard let indexPathsForSelectedItems, !indexPathsForSelectedItems.isEmpty else {
      return
    }
    guard let transitionCoordinator = transitionCoordinator else {
      for indexPath in indexPathsForSelectedItems {
        deselectItem(at: indexPath, animated: animated)
      }
      return
    }
    transitionCoordinator.animate(alongsideTransition: { [unowned self] context in
      for indexPath in indexPathsForSelectedItems {
        deselectItem(at: indexPath, animated: context.isAnimated)
      }
    }, completion: { [unowned self] context in
      if context.isCancelled {
        for indexPath in indexPathsForSelectedItems {
          selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
      }
    })
  }

  // Register

  @inlinable
  public func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) {
    register(cellClass, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  public func register<Cell: UICollectionViewCell & NibLoadable>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) {
    register(cellClass.nib, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  public func register<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String) {
    register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  @inlinable
  public func register<View: UICollectionReusableView & NibLoadable>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String) {
    register(viewClass.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  // Unregister

  @inlinable
  public func unregister<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) {
    register(nil as AnyClass?, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  public func unregister<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String) {
    register(nil as AnyClass?, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  // Dequeue

  @inlinable
  public func dequeue<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier, for indexPath: IndexPath) -> Cell {
    dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
  }

  @inlinable
  public func dequeueConfigured<Cell: UICollectionViewCell & ContentConfiguring>( _ cellClass: Cell.Type, for indexPath: IndexPath, with content: Cell.Content) -> Cell {
    let cell = dequeue(cellClass, for: indexPath)
    cell.configure(content)
    return cell
  }

  @inlinable
  public func dequeue<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String, for indexPath: IndexPath) -> View {
    dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! View
  }
}
