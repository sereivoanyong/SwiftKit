//
//  UICollectionView.swift
//
//  Created by Sereivoan Yong on 8/2/17.
//

import UIKit

#if DEBUG
private var registeredCellsKey: Void?
private var registeredSupplementaryViewsKey: Void?
#endif

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

#if DEBUG
  public private(set) var registeredCells: [String: (cellClass: UICollectionViewCell.Type, isNib: Bool)] {
    get { return associatedValue(default: [:], forKey: &registeredCellsKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &registeredCellsKey, with: self) }
  }

  public private(set) var registeredSupplementaryViews: [String: (viewClass: UICollectionReusableView.Type, isNib: Bool, kind: String)] {
    get { return associatedValue(default: [:], forKey: &registeredSupplementaryViewsKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &registeredSupplementaryViewsKey, with: self) }
  }
#endif

  // Register

  public func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String? = nil) {
    let identifier = identifier ?? cellClass.reuseIdentifier
    register(cellClass, forCellWithReuseIdentifier: identifier)
#if DEBUG
    registeredCells[identifier] = (cellClass, false)
#endif
  }

  public func register<Cell: UICollectionViewCell & NibLoadable>(_ cellClass: Cell.Type, identifier: String? = nil) {
    let identifier = identifier ?? cellClass.reuseIdentifier
    register(cellClass.nib, forCellWithReuseIdentifier: identifier)
#if DEBUG
    registeredCells[identifier] = (cellClass, true)
#endif
  }

  public func register<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String? = nil, ofKind kind: String) {
    let identifier = identifier ?? viewClass.reuseIdentifier
    register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
#if DEBUG
    registeredSupplementaryViews[identifier] = (viewClass, false, kind)
#endif
  }

  public func register<View: UICollectionReusableView & NibLoadable>(_ viewClass: View.Type, identifier: String? = nil, ofKind kind: String) {
    let identifier = identifier ?? viewClass.reuseIdentifier
    register(viewClass.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
#if DEBUG
    registeredSupplementaryViews[identifier] = (viewClass, true, kind)
#endif
  }

  // Unregister

  public func unregister<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String? = nil) {
    let identifier = identifier ?? cellClass.reuseIdentifier
    register(nil as AnyClass?, forCellWithReuseIdentifier: identifier)
#if DEBUG
    registeredCells[identifier] = nil
#endif
  }

  public func unregister<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String? = nil, ofKind kind: String) {
    let identifier = identifier ?? viewClass.reuseIdentifier
    register(nil as AnyClass?, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
#if DEBUG
    registeredSupplementaryViews[identifier] = nil
#endif
  }

  // Dequeue

  @inlinable
  public func dequeue<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String? = nil, for indexPath: IndexPath) -> Cell {
    let identifier = identifier ?? cellClass.reuseIdentifier
    return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
  }

  @inlinable
  public func dequeueConfigured<Cell: UICollectionViewCell & ContentConfiguring>( _ cellClass: Cell.Type, for indexPath: IndexPath, with content: Cell.Content) -> Cell {
    let cell = dequeue(cellClass, for: indexPath)
    cell.configure(content)
    return cell
  }

  @inlinable
  public func dequeue<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String? = nil, ofKind kind: String, for indexPath: IndexPath) -> View {
    let identifier = identifier ?? viewClass.reuseIdentifier
    return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! View
  }
}
