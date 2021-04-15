//
//  UICollectionView.swift
//
//  Created by Sereivoan Yong on 8/2/17.
//

#if canImport(UIKit)
import UIKit

extension UICollectionView {
  
  public typealias CellProvider<Item> = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
  
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

  // Register

  @inlinable
  final public func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self)) {
    register(cellClass, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  final public func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) where Cell: Reusable {
    register(cellClass, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  final public func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) where Cell: NibReusable {
    register(cellClass.nib, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  final public func register<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = String(describing: View.self), ofKind kind: String) {
    register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  @inlinable
  final public func register<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String) where View: Reusable {
    register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  @inlinable
  final public func register<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String) where View: NibReusable {
    register(viewClass.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  // Unregister

  @inlinable
  final public func unregister<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self)) {
    register(nil as AnyClass?, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  final public func unregister<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) where Cell: Reusable {
    register(nil as AnyClass?, forCellWithReuseIdentifier: identifier)
  }

  @inlinable
  final public func unregister<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = String(describing: View.self), ofKind kind: String) {
    register(nil as AnyClass?, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  @inlinable
  final public func unregister<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String) where View: Reusable {
    register(nil as AnyClass?, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
  }

  // Dequeue

  @inlinable
  final public func dequeue<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self), for indexPath: IndexPath) -> Cell {
    return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
  }

  @inlinable
  final public func dequeue<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier, for indexPath: IndexPath) -> Cell where Cell: Reusable {
    return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
  }

  @inlinable
  final public func dequeue<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = String(describing: View.self), ofKind kind: String, for indexPath: IndexPath) -> View {
    return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! View
  }

  @inlinable
  final public func dequeue<View: UICollectionReusableView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier, ofKind kind: String, for indexPath: IndexPath) -> View where View: Reusable {
    return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! View
  }

  // Swizzle for functionalities

  private static let swizzlingHandler: Void = {
    let klass = UICollectionView.self
    class_exchangeInstanceMethodImplementations(klass, #selector(layoutSubviews), #selector(_sk_cv_layoutSubviews))
  }()

  private static var invalidatesCollectionViewLayoutOnBoundsChangeKey: Void?

  /// A `Bool` value that determines whether the collection view invalidates the layout on bounds change.
  final public var invalidatesCollectionViewLayoutOnBoundsChange: Bool {
    get { associatedValue(forKey: &Self.invalidatesCollectionViewLayoutOnBoundsChangeKey) ?? false }
    set { _ = Self.swizzlingHandler; setAssociatedValue(newValue, forKey: &Self.invalidatesCollectionViewLayoutOnBoundsChangeKey) }
  }

  private static var boundsWhenCollectionViewLayoutInvalidatedKey: Void?

  final private var boundsWhenCollectionViewLayoutInvalidated: CGRect? {
    get { associatedValue(forKey: &Self.boundsWhenCollectionViewLayoutInvalidatedKey) }
    set { setAssociatedValue(newValue, forKey: &Self.boundsWhenCollectionViewLayoutInvalidatedKey) }
  }

  @objc private func _sk_cv_layoutSubviews() {
    _sk_cv_layoutSubviews()
    
    if invalidatesCollectionViewLayoutOnBoundsChange && bounds != boundsWhenCollectionViewLayoutInvalidated {
      boundsWhenCollectionViewLayoutInvalidated = bounds
      collectionViewLayout.invalidateLayout()
    }
  }
}
#endif
