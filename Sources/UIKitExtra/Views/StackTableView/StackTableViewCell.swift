//
//  StackTableViewCell.swift
//
//  Created by Sereivoan Yong on 12/16/20.
//

#if os(iOS)

import UIKit

/// Indicates that a row in an `StackTableView` should be highlighted when the user touches it.
///
/// Rows that are added to an `StackTableView` can conform to this protocol to have their
/// background color automatically change to a highlighted color (or some other custom behavior defined by the row) when the user is pressing down on
/// them.
public protocol StackTableViewHighlightable: UIView {

  /// Checked when the user touches down on a row to determine if the row should be highlighted.
  ///
  /// The default implementation of this method always returns `true`.
  var isHighlightable: Bool { get }

  /// Called when the highlighted state of the row changes.
  /// Override this method to provide custom highlighting behavior for the row.
  ///
  /// The default implementation of this method changes the background color of the row to the `rowHighlightColor`.
  func setIsHighlighted(_ isHighlighted: Bool)
}

extension StackTableViewHighlightable {

  public var isHighlightable: Bool {
    return true
  }

  public func setIsHighlighted(_ isHighlighted: Bool) {
    guard let cell = superview as? StackTableViewCell else { return }
    cell.backgroundColor = isHighlighted ? cell.highlightColor : cell.unhighlightColor
  }
}

/// Notifies a row in an `StackTableView` when it receives a user tap.
///
/// Rows that are added to an `StackTableView` can conform to this protocol to be notified when a
/// user taps on the row. This notification happens regardless of whether the row has a tap handler
/// set for it or not.
///
/// This notification can be used to implement default behavior in a view that should always happen
/// when that view is tapped.
public protocol StackTableViewTappable: UIView {

  /// Called when the row is tapped by the user.
  func didTapView()
}

/// A view that wraps every row in a stack view.
open class StackTableViewCell: UIView {

  private var tapGestureRecognizer: UITapGestureRecognizer!

  var unhighlightColor: UIColor? {
    didSet {
      if !isHighlighted {
        backgroundColor = unhighlightColor
      }
    }
  }

  var highlightColor: UIColor? {
    didSet {
      if isHighlighted {
        backgroundColor = highlightColor
      }
    }
  }

  // MARK: Public

  public let contentView: UIView

  open var accessoryView: UIView? {
    didSet {
      guard accessoryView != oldValue else {
        return
      }
      oldValue?.removeFromSuperview()
      if let accessoryView = accessoryView {
        accessoryView.setContentHuggingPriority(.required, for: .horizontal)
        accessoryView.setContentCompressionResistancePriority(.required, for: .horizontal)
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accessoryView)

        contentViewConstraints[3].isActive = false
        contentViewConstraints[3] = accessoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)

        NSLayoutConstraint.activate([
          contentViewConstraints[3],
          accessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          layoutMarginsGuide.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor),
        ])
      } else {
        contentViewConstraints[3].isActive = false
        contentViewConstraints[3] = layoutMarginsGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        contentViewConstraints[3].isActive = true
      }
    }
  }

  open private(set) var isHighlighted: Bool = false

  /// Edge constraints (top, left, bottom, right) of `contentView`
  open private(set) var contentViewConstraints: [NSLayoutConstraint]!

  // MARK: Lifecycle

  public init(contentView: UIView) {
    self.contentView = contentView
    super.init(frame: .zero)

    clipsToBounds = true
    if #available(iOS 11.0, *) {
      insetsLayoutMarginsFromSafeArea = false
    }
    translatesAutoresizingMaskIntoConstraints = false

    contentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentView)

    contentViewConstraints = [
      contentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      layoutMarginsGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      layoutMarginsGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ]

    contentViewConstraints[2].priority = .required - 1
    NSLayoutConstraint.activate(contentViewConstraints)

    if contentView is StackTableViewTappable {
      tapGestureRecognizer = UITapGestureRecognizer()
      tapGestureRecognizer.addTarget(self, action: #selector(handleTap(_:)))
      tapGestureRecognizer.delegate = self
      addGestureRecognizer(tapGestureRecognizer)
    }
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: UIResponder

  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard contentView.isUserInteractionEnabled else { return }

    if let contentView = contentView as? StackTableViewHighlightable, contentView.isHighlightable {
      isHighlighted = true
      contentView.setIsHighlighted(true)
    }
  }

  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    guard contentView.isUserInteractionEnabled, let touch = touches.first else { return }

    if let contentView = contentView as? StackTableViewHighlightable, contentView.isHighlightable {
      let location = touch.location(in: self)
      let isPointInside = point(inside: location, with: event)
      isHighlighted = isPointInside
      contentView.setIsHighlighted(isPointInside)
    }
  }

  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    guard contentView.isUserInteractionEnabled else { return }

    if let contentView = contentView as? StackTableViewHighlightable, contentView.isHighlightable {
      isHighlighted = false
      contentView.setIsHighlighted(false)
    }
  }

  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    guard contentView.isUserInteractionEnabled else { return }

    if let contentView = contentView as? StackTableViewHighlightable, contentView.isHighlightable {
      isHighlighted = false
      contentView.setIsHighlighted(false)
    }
  }

  // MARK: Internal

  var tapHandler: ((UIView) -> Void)? {
    didSet {
      tapGestureRecognizer.isEnabled = tapHandler != nil
    }
  }

  // MARK: Private

  @objc private func handleTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
    guard contentView.isUserInteractionEnabled else { return }
    (contentView as? StackTableViewTappable)?.didTapView()
    tapHandler?(contentView)
  }
}

extension StackTableViewCell: UIGestureRecognizerDelegate {
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    guard let view = gestureRecognizer.view else { return false }
    
    let location = touch.location(in: view)
    var hitView = view.hitTest(location, with: nil)
    
    // Traverse the chain of superviews looking for any UIControls.
    while hitView != view && hitView != nil {
      if hitView is UIControl {
        // Ensure UIControls get the touches instead of the tap gesture.
        return false
      }
      hitView = hitView?.superview
    }
    
    return true
  }
}

#endif
