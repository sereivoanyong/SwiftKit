//
//  StackTableView.swift
//
//  Created by Sereivoan Yong on 12/16/20.
//

#if os(iOS)

import UIKit

/// A simple class for laying out a collection of views with a convenient API, while leveraging the
/// power of Auto Layout.
open class StackTableView: UIScrollView {

  /// Edge constraints (top, left, bottom, right) of `stackView`
  lazy private var stackViewEdgeConstraints: [NSLayoutConstraint] = [
    stackView.topAnchor.constraint(equalTo: topAnchor),
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
    bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
    trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
  ]

  lazy private var stackViewDimensionConstraint: NSLayoutConstraint = stackViewDimensionConstraint(for: axis)

  private var stackViewAxisObservation: NSKeyValueObservation?

  /// `arrangedSubviews` must not be modified directly.
  public let stackView = StackView()

  /// The direction that rows are laid out in the stack view.
  ///
  /// If `axis` is `.vertical`, rows will be laid out in a vertical column. If `axis` is
  /// `.horizontal`, rows will be laid out horizontally, side-by-side.
  ///
  /// This property also controls the direction of scrolling in the stack view. If `axis` is
  /// `.vertical`, the stack view will scroll vertically, and rows will stretch to fill the width of
  /// the stack view. If `axis` is `.horizontal`, the stack view will scroll horizontally, and rows
  /// will be sized to fill the height of the stack view.
  ///
  /// The default value is `.vertical`.
  @inlinable
  open var axis: NSLayoutConstraint.Axis {
    get { return stackView.axis }
    set { stackView.axis = newValue }
  }

  // MARK: Styling Rows

  open var cellPreservesSuperviewLayoutMargins: Bool = false

  /// The background color of rows in the stack view.
  ///
  /// This background color will be used for any new row that is added to the stack view.
  /// The default color is `.clear`.
  open var cellBackgroundColor: UIColor = .clear

  /// The highlight background color of rows in the stack view.
  ///
  /// This highlight background color will be used for any new row that is added to the stack view.
  /// The default color is #D9D9D9 (RGB 217, 217, 217).
  open var cellHighlightColor: UIColor = UIColor(red: 217 / 255, green: 217 / 255, blue: 217 / 255, alpha: 1)

  /// Specifies the default inset of rows.
  ///
  /// This inset will be used for any new row that is added to the stack view.
  ///
  /// You can use this property to add space between a row and the left and right edges of the stack
  /// view and the rows above and below it. Positive inset values move the row inward and away
  /// from the stack view edges and away from rows above and below.
  ///
  /// The default inset is 15pt on each side and 12pt on the top and bottom.
  open var cellLayoutMargins: UIEdgeInsets = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)

  // MARK: Animation Durations

  open var hideAnimationDuration: TimeInterval = 0.3
  open var insertAnimationDuration: TimeInterval = 0.3
  open var removeAnimationDuration: TimeInterval = 0.3

  // MARK: Lifecycle

  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)

    NSLayoutConstraint.activate(stackViewEdgeConstraints)
    stackViewDimensionConstraint.isActive = true

    stackViewAxisObservation = stackView.observe(\.axis) { [unowned self] _, _ in
      stackViewDimensionConstraint.isActive = false
      stackViewDimensionConstraint = stackViewDimensionConstraint(for: axis)
      stackViewDimensionConstraint.isActive = true
    }
  }

  // MARK: Adding and Removing Cells Using Content View

  /// Adds a row to the end of the stack view.
  ///
  /// If `animated` is `true`, the insertion is animated.
  open func addCell(contentView: UIView, animated: Bool = false) {
    insertCell(contentView: contentView, forRow: numberOfRows, animated: animated)
  }

  open func insertCell(contentView: UIView, forRow row: Int, animated: Bool = false) {
    let cellToRemove = cell(contentView: contentView)

    let cell = createCell(contentView: contentView)
    setValueIfNotEqual(cellLayoutMargins, for: \.layoutMargins, on: cell)
    setValueIfNotEqual(cellPreservesSuperviewLayoutMargins, for: \.preservesSuperviewLayoutMargins, on: cell)
    setValueIfNotEqual(cellBackgroundColor, for: \.unhighlightColor, on: cell)
    setValueIfNotEqual(cellHighlightColor, for: \.highlightColor, on: cell)
    configureCell(cell)
    stackView.insertArrangedSubview(cell, at: row)
    cells.insert(cell, at: row)

    if let cellToRemove = cellToRemove, let rowToRemove = self.row(for: cellToRemove) {
      removeCell(forRow: rowToRemove, animated: false)
    }

    if animated {
      cell.alpha = 0
      layoutIfNeeded()
      UIView.animate(withDuration: insertAnimationDuration) {
        cell.alpha = 1
      }
    }
  }

  /// Removes the given row from the stack view.
  ///
  /// If `animated` is `true`, the removal is animated.
  open func removeCell(contentView: UIView, animated: Bool = false) {
    if let row = rowForCell(contentView: contentView) {
      removeCell(forRow: row, animated: animated)
    }
  }

  // MARK: Adding and Removing Cells

  open func addCell(_ cell: StackTableViewCell, animated: Bool) {
    insertCell(cell, forRow: numberOfRows, animated: animated)
  }

  open func insertCell(_ cell: StackTableViewCell, forRow row: Int, animated: Bool) {
    setValueIfNotEqual(cellLayoutMargins, for: \.layoutMargins, on: cell)
    setValueIfNotEqual(cellPreservesSuperviewLayoutMargins, for: \.preservesSuperviewLayoutMargins, on: cell)
    setValueIfNotEqual(cellBackgroundColor, for: \.unhighlightColor, on: cell)
    setValueIfNotEqual(cellHighlightColor, for: \.highlightColor, on: cell)
    configureCell(cell)
    cells.insert(cell, at: row)
    stackView.insertArrangedSubview(cell, at: row)

    if animated {
      cell.alpha = 0
      layoutIfNeeded()
      UIView.animate(withDuration: insertAnimationDuration) {
        cell.alpha = 1
      }
    }
  }

  open func removeCell(forRow row: Int, animated: Bool) {
    let cell = cell(forRow: row)
    if animated {
      UIView.animate(withDuration: removeAnimationDuration, animations: {
        cell.isHidden = true
      }, completion: { _ in
        cell.removeFromSuperview()
      })
    } else {
      cell.removeFromSuperview()
    }
    cells.remove(at: row)
  }

  /// Removes all the rows in the stack view.
  ///
  /// If `animated` is `true`, the removals are animated.
  open func removeAllCells(animated: Bool = false) {
    for row in (0..<numberOfRows).reversed() {
      removeCell(forRow: row, animated: animated)
    }
  }

  // MARK: Accessing Cells

  @inlinable
  open var numberOfRows: Int {
    return cells.count
  }

  /// Returns an array containing of all the rows in the stack view.
  ///
  /// The rows in the returned array are in the order they appear visually in the stack view.
  open private(set) var cells: [StackTableViewCell] = []

  open func cell(forRow row: Int) -> StackTableViewCell {
    return cells[row]
  }

  open func row(for cell: StackTableViewCell) -> Int? {
    return cells.firstIndex(of: cell)
  }

  open func cell(contentView: UIView) -> StackTableViewCell? {
    if let cell = contentView.superview as? StackTableViewCell, cells.contains(cell) {
      return cell
    }
    return nil
  }

  open func rowForCell(contentView: UIView) -> Int? {
    if let cell = contentView.superview as? StackTableViewCell {
      return row(for: cell)
    }
    return nil
  }

  /// Returns `true` if the given row is present in the stack view, `false` otherwise.
  open func containsCell(contentView: UIView) -> Bool {
    return cell(contentView: contentView) != nil
  }

  // MARK: Hiding and Showing Rows

  /// Hides the given row, making it invisible.
  ///
  /// If `animated` is `true`, the change is animated.
  open func hideCell(contentView: UIView, animated: Bool = false) {
    setCellHidden(true, contentView: contentView, animated: animated)
  }

  /// Shows the given row, making it visible.
  ///
  /// If `animated` is `true`, the change is animated.
  open func showCell(contentView: UIView, animated: Bool = false) {
    setCellHidden(false, contentView: contentView, animated: animated)
  }

  /// Hides the given row if `isHidden` is `true`, or shows the given row if `isHidden` is `false`.
  ///
  /// If `animated` is `true`, the change is animated.
  open func setCellHidden(_ isCellHidden: Bool, contentView: UIView, animated: Bool = false) {
    guard let cell = cell(contentView: contentView), cell.isHidden != isCellHidden else {
      return
    }

    if animated {
      UIView.animate(withDuration: hideAnimationDuration) {
        cell.isHidden = isCellHidden
        cell.layoutIfNeeded()
      }
    } else {
      cell.isHidden = isCellHidden
    }
  }

  /// Returns `true` if the given row is hidden, `false` otherwise.
  open func isCellHidden(forRow row: Int) -> Bool {
    return cell(forRow: row).isHidden
  }

  // MARK: Handling User Interaction

  /// Sets a closure that will be called when the given row in the stack view is tapped by the user.
  ///
  /// The handler will be passed the row.
  open func setTapHandlerForCell<ContentView: UIView>(contentView: ContentView, handler: ((ContentView) -> Void)?) {
    guard let cell = cell(contentView: contentView) else {
      return
    }

    if let handler = handler {
      cell.tapHandler = { contentView in
        if let contentView = contentView as? ContentView {
          handler(contentView)
        }
      }
    } else {
      cell.tapHandler = nil
    }
  }

  // MARK: Extending StackTableView

  /// Returns the `StackTableViewCell` to be used for the given row.
  ///
  /// An instance of `StackTableViewCell` wraps every row in the stack view.
  ///
  /// Subclasses can override this method to return a custom `StackTableViewCell` subclass, for example
  /// to add custom behavior or functionality that is not provided by default.
  ///
  /// If you customize the values of some properties of `StackTableViewCell` in this method, these values
  /// may be overwritten by default values after the cell is returned. To customize the values of
  /// properties of the cell, override `configureCell(_:)` and perform the customization there,
  /// rather than on the cell returned from this method.
  open func createCell(contentView: UIView) -> StackTableViewCell {
    return StackTableViewCell(contentView: contentView)
  }

  /// Allows subclasses to configure the properties of the given `StackTableViewCell`.
  ///
  /// This method is called for newly created cells after the default values of any properties of
  /// the cell have been set by the superclass.
  ///
  /// The default implementation of this method does nothing.
  open func configureCell(_ cell: StackTableViewCell) {

  }

  // MARK: Modifying the Scroll Position

  open func scrollToCell(forRow row: Int, animated: Bool = false) {
    let cell = cell(forRow: row)
    scrollRectToVisible(cell.frame, animated: animated)
  }

  /// Scrolls the given row onto screen so that it is fully visible.
  ///
  /// If `animated` is `true`, the scroll is animated. If the row is already fully visible, this
  /// method does nothing.
  open func scrollToCell(contentView: UIView, animated: Bool = false) {
    if let cell = cell(contentView: contentView) {
      scrollRectToVisible(cell.frame, animated: animated)
    }
  }

  // MARK: - Private

  private func stackViewDimensionConstraint(for axis: NSLayoutConstraint.Axis) -> NSLayoutConstraint {
    switch axis {
    case .horizontal:
      return stackView.heightAnchor.constraint(equalTo: heightAnchor)
    case .vertical:
      return stackView.widthAnchor.constraint(equalTo: widthAnchor)
    @unknown default:
      return stackView.heightAnchor.constraint(equalTo: heightAnchor)
    }
  }
}

#endif
