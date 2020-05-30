//
//  UITableView.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

// MARK: - Floating Header/Footer Views

extension UITableView {
  
  private static var allowsHeaderViewsToFloatKey: Void?
  @objc final public var allowsHeaderViewsToFloat: Bool {
    get { return associatedValue(forKey: &Self.allowsHeaderViewsToFloatKey, default: true) }
    set { setAssociatedValue(newValue, forKey: &Self.allowsHeaderViewsToFloatKey) }
  }
  
  private static var allowsFooterViewsToFloatKey: Void?
  @objc final public var allowsFooterViewsToFloat: Bool {
    get { return associatedValue(forKey: &Self.allowsFooterViewsToFloatKey, default: true) }
    set { setAssociatedValue(newValue, forKey: &Self.allowsFooterViewsToFloatKey) }
  }
  
  private static var _headerAndFooterViewsFloatKey: Void?
  @objc final public var _headerAndFooterViewsFloat: Bool {
    get { return associatedValue(forKey: &Self._headerAndFooterViewsFloatKey, default: true) }
    set { setAssociatedValue(newValue, forKey: &Self._headerAndFooterViewsFloatKey) }
  }
  
  @inlinable public convenience init(style: Style) {
    self.init(frame: .zero, style: style)
  }
  
  /// Selects rows in the table view identified by index paths.
  /// - Parameters:
  ///   - indexPath: index paths identifying rows in the table view.
  ///   - animated: true if you want to animate the selection and any change in position; false if the change should be immediate.
  final public func selectRows(at indexPaths: [IndexPath], animated: Bool) {
    for indexPath in indexPaths {
      selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }
  }
  
  /// Deselects all selected rows and returns their index paths, with an option to animate the deselection.
  /// - Parameters:
  ///   - animated: true if you want to animate the deselection, and false if the change should be immediate.
  @discardableResult
  final public func deselectAllRows(animated: Bool) -> [IndexPath]? {
    guard let indexPaths = indexPathsForSelectedRows else {
      return nil
    }
    for indexPath in indexPaths {
      deselectRow(at: indexPath, animated: animated)
    }
    return indexPaths
  }
  
  /// Reloads the rows and sections of the table view
  final public func reloadData(completion: @escaping (Bool) -> Void) {
    UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: completion)
  }
  
  /// Returns a boolean value indicating whether the table view has the provided index path
  final public func hasIndexPath(_ indexPath: IndexPath) -> Bool {
    return 0..<numberOfSections ~= indexPath.section && 0..<numberOfRows(inSection: indexPath.section) ~= indexPath.row
  }
  
  final public func disableEstimatedHeightIfUsed() {
    if #available(iOS 11.0, *) {
      estimatedSectionHeaderHeight = 0
      estimatedSectionFooterHeight = 0
      estimatedRowHeight = 0
    }
  }
  
  final public func deselectSelectedRows(animated: Bool, transitionCoordinator: UIViewControllerTransitionCoordinator? = nil) {
    guard let selectedIndexPaths = indexPathsForSelectedRows, !selectedIndexPaths.isEmpty else {
      return
    }
    guard let transitionCoordinator = transitionCoordinator else {
      for indexPath in selectedIndexPaths {
        deselectRow(at: indexPath, animated: animated)
      }
      return
    }
    transitionCoordinator.animate(alongsideTransition: { [unowned self] context in
      for indexPath in selectedIndexPaths {
        self.deselectRow(at: indexPath, animated: context.isAnimated)
      }
    }, completion: { [unowned self] context in
      if context.isCancelled {
        for indexPath in selectedIndexPaths {
          self.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
      }
    })
  }
  
  final public func setNeedsUpdate() {
    beginUpdates()
    endUpdates()
  }
  
  final public func performUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
    if #available(iOS 11, *) {
      performBatchUpdates(updates, completion: completion)
    } else {
      if let completion = completion {
        CATransaction.begin()
        CATransaction.setCompletionBlock { completion(true) }
        beginUpdates()
        updates?()
        endUpdates()
        CATransaction.commit()
      } else {
        beginUpdates()
        updates?()
        endUpdates()
      }
    }
  }
  
  // HeaderView/FootersView
  
  @inlinable final public func register<View>(_ viewClass: View.Type, identifier: String = String(describing: View.self)) where View: UITableViewHeaderFooterView {
    register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
  }
  
  @inlinable final public func unregister<View>(_ viewClass: View.Type, identifier: String = String(describing: View.self)) where View: UITableViewHeaderFooterView {
    register(nil as AnyClass?, forHeaderFooterViewReuseIdentifier: identifier)
  }
  
  @inlinable final public func dequeue<View>(_ viewClass: View.Type, identifier: String = String(describing: View.self)) -> View where View: UITableViewHeaderFooterView {
    return unsafeDowncast(dequeueReusableHeaderFooterView(withIdentifier: identifier).unsafelyUnwrapped, to: View.self)
  }
  
  // Cell
  
  @inlinable final public func register<Cell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self)) where Cell: UITableViewCell {
    register(cellClass, forCellReuseIdentifier: identifier)
  }
  
  @inlinable final public func unregister<Cell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self)) where Cell: UITableViewCell {
    register(nil as AnyClass?, forCellReuseIdentifier: identifier)
  }
  
  @inlinable final public func dequeue<Cell>(_ cellClass: Cell.Type, identifier: String = String(describing: Cell.self), for indexPath: IndexPath) -> Cell where Cell: UITableViewCell {
    return unsafeDowncast(dequeueReusableCell(withIdentifier: identifier, for: indexPath), to: Cell.self)
  }
  
  @inlinable final public func dequeue<Cell>(_ cellClass: Cell.Type, style: UITableViewCell.CellStyle) -> Cell where Cell: UITableViewCell {
    let identifier = String(describing: cellClass)
    return dequeueReusableCell(withIdentifier: identifier) as? Cell ?? Cell(style: style, reuseIdentifier: identifier)
  }
}
#endif
