//
//  UITableView.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

import UIKit

extension UITableView {

  public typealias CellProvider<Item> = (UITableView, IndexPath, Item) -> UITableViewCell?

  private static var allowsHeaderViewsToFloatKey: Void?
  @objc final public var allowsHeaderViewsToFloat: Bool {
    get { return associatedValue(default: true, forKey: &Self.allowsHeaderViewsToFloatKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &Self.allowsHeaderViewsToFloatKey, with: self) }
  }

  private static var allowsFooterViewsToFloatKey: Void?
  @objc final public var allowsFooterViewsToFloat: Bool {
    get { return associatedValue(default: true, forKey: &Self.allowsFooterViewsToFloatKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &Self.allowsFooterViewsToFloatKey, with: self) }
  }

  public var _headerAndFooterViewsFloat: Bool {
    get { return valueIfResponds(forKey: "_headerAndFooterViewsFloat") as? Bool ?? false }
    set { performIfResponds(Selector(("_setHeaderAndFooterViewsFloat:")), with: newValue as NSNumber) }
  }

  @inlinable
  public convenience init(style: Style) {
    self.init(frame: .zero, style: style)
  }

  /// Selects rows in the table view identified by index paths.
  /// - Parameters:
  ///   - indexPath: index paths identifying rows in the table view.
  ///   - animated: true if you want to animate the selection and any change in position; false if the change should be immediate.
  public func selectRows(at indexPaths: [IndexPath], animated: Bool) {
    for indexPath in indexPaths {
      selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }
  }

  /// Deselects all selected rows and returns their index paths, with an option to animate the deselection.
  /// - Parameters:
  ///   - animated: true if you want to animate the deselection, and false if the change should be immediate.
  @discardableResult
  public func deselectAllRows(animated: Bool) -> [IndexPath]? {
    guard let indexPathsForSelectedRows else {
      return nil
    }
    for indexPath in indexPathsForSelectedRows {
      deselectRow(at: indexPath, animated: animated)
    }
    return indexPathsForSelectedRows
  }

  /// Returns a boolean value indicating whether the table view has the provided index path
  public func hasIndexPath(_ indexPath: IndexPath) -> Bool {
    return 0..<numberOfSections ~= indexPath.section && 0..<numberOfRows(inSection: indexPath.section) ~= indexPath.row
  }

  public func indexPathForCellContainingView(_ view: UIView) -> IndexPath? {
    if let cell = view as? UITableViewCell {
      return indexPath(for: cell)
    }
    if let superview = view.superview {
      return indexPathForCellContainingView(superview)
    }
    return nil
  }

  public func disableEstimatedHeights() {
    estimatedSectionHeaderHeight = 0
    estimatedSectionFooterHeight = 0
    estimatedRowHeight = 0
  }

  public func deselectSelectedRows(animated: Bool, transitionCoordinator: UIViewControllerTransitionCoordinator? = nil) {
    guard let indexPathsForSelectedRows, !indexPathsForSelectedRows.isEmpty else {
      return
    }
    guard let transitionCoordinator else {
      for indexPath in indexPathsForSelectedRows {
        deselectRow(at: indexPath, animated: animated)
      }
      return
    }
    transitionCoordinator.animate(alongsideTransition: { [unowned self] context in
      for indexPath in indexPathsForSelectedRows {
        self.deselectRow(at: indexPath, animated: context.isAnimated)
      }
    }, completion: { [unowned self] context in
      if context.isCancelled {
        for indexPath in indexPathsForSelectedRows {
          self.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
      }
    })
  }

  public func setNeedsUpdate() {
    beginUpdates()
    endUpdates()
  }

  // Register

  @inlinable
  public func register<Cell: UITableViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) {
    register(cellClass, forCellReuseIdentifier: identifier)
  }

  @inlinable
  public func register<Cell: UITableViewCell & NibLoadable>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) {
    register(cellClass.nib, forCellReuseIdentifier: identifier)
  }

  @inlinable
  public func register<View: UITableViewHeaderFooterView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier) {
    register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
  }

  @inlinable
  public func register<View: UITableViewHeaderFooterView & NibLoadable>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier) {
    register(viewClass.nib, forHeaderFooterViewReuseIdentifier: identifier)
  }

  // Unregister

  @inlinable
  public func unregister<Cell: UITableViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier) {
    register(nil as AnyClass?, forCellReuseIdentifier: identifier)
  }

  @inlinable
  public func unregister<View: UITableViewHeaderFooterView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier) {
    register(nil as AnyClass?, forHeaderFooterViewReuseIdentifier: identifier)
  }

  // Dequeue

  @inlinable
  public func dequeue<Cell: UITableViewCell>(_ cellClass: Cell.Type, style: UITableViewCell.CellStyle, identifier: String = Cell.reuseIdentifier) -> Cell {
    return dequeueReusableCell(withIdentifier: identifier) as! Cell? ?? Cell(style: style, reuseIdentifier: identifier)
  }

  @inlinable
  public func dequeue<Cell: UITableViewCell>(_ cellClass: Cell.Type, identifier: String = Cell.reuseIdentifier, for indexPath: IndexPath) -> Cell {
    return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
  }

  @inlinable
  public func dequeue<View: UITableViewHeaderFooterView>(_ viewClass: View.Type, identifier: String = View.reuseIdentifier) -> View {
    return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! View
  }
}
