//
//  UIView.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

extension UIView {

  final public var owningViewController: UIViewController? {
    if let next = next {
      if let viewController = next as? UIViewController {
        return viewController
      }
      if let view = next as? UIView {
        return view.owningViewController
      }
    }
    return nil
  }
  
  final public func viewToResepectLayoutMargins() -> UIView {
    if preservesSuperviewLayoutMargins, let superview = superview {
      return superview.viewToResepectLayoutMargins()
    }
    return self
  }
  
  /// Returns a snapshot of an entire bounds of the view
  final public func snapshot() -> UIImage {
    return UIImage(size: bounds.size, opaque: false, scale: UIScreen.main.scale, actions: layer.render(in:))
  }
  
  final public func sizeThatFits(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
    return sizeThatFits(CGSize(width: width, height: height))
  }
  
  final public var readableContentFrame: CGRect {
    return readableContentGuide.layoutFrame
  }
  
  final public var readableContentInsets: UIEdgeInsets {
    let frame = readableContentGuide.layoutFrame
    return UIEdgeInsets(top: frame.minY, left: frame.minX, bottom: bounds.height - frame.maxY, right: bounds.width - frame.maxX)
  }
  
  @available(iOS 11.0, *)
  final public var safeAreaFrame: CGRect {
    return bounds.inset(by: safeAreaInsets)
  }
  
  final public var safeAreaInsetsIfAvailable: UIEdgeInsets {
    if #available(iOS 11.0, *) {
      return safeAreaInsets
    } else {
      return .zero
    }
  }
  
  final public func addSubviews(_ views: [UIView]) {
    for view in views {
      addSubview(view)
    }
  }
  
  final public func removeSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }
  
  @discardableResult
  final public func addTapGestureRecognizer(handler: @escaping (UITapGestureRecognizer) -> Void, configurationHandler: ((UITapGestureRecognizer) -> Void)? = nil) -> UITapGestureRecognizer {
    isUserInteractionEnabled = true
    let tapGestureRecognizer = UITapGestureRecognizer(handler: handler)
    tapGestureRecognizer.cancelsTouchesInView = false
    configurationHandler?(tapGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    return tapGestureRecognizer
  }
  
  @discardableResult
  final public func addTapGestureRecognizerToEndEditing(_ force: Bool = true) -> UITapGestureRecognizer {
    return addTapGestureRecognizer { [unowned self] _ in
      self.endEditing(force)
    }
  }
  
  /// Sets the priority with which a view resists being made larger or smaller than its intrinsic size
  final public func setContentResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
    setContentHuggingPriority(priority, for: axis)
    setContentCompressionResistancePriority(priority, for: axis)
  }
  
  /// Sets the priority with which a view resists being made larger or smaller than its intrinsic size
  final public func setContentResistancePriority(_ priority: UILayoutPriority) {
    setContentResistancePriority(priority, for: .horizontal)
    setContentResistancePriority(priority, for: .vertical)
  }
}

extension UIView.AutoresizingMask {
  
  public static var flexibleSize: UIView.AutoresizingMask {
    return [.flexibleWidth, .flexibleHeight]
  }
  
  public static var flexibleCenterX: UIView.AutoresizingMask {
    return [.flexibleLeftMargin, .flexibleRightMargin]
  }
  
  public static var flexibleCenterY: UIView.AutoresizingMask {
    return [.flexibleTopMargin, .flexibleBottomMargin]
  }
  
  public static var flexibleCenter: UIView.AutoresizingMask {
    return [.flexibleCenterX, .flexibleCenterY]
  }
}

extension NSObjectProtocol where Self: UIView {
  
  @inlinable
  public var withAutoLayout: Self {
    with(\.translatesAutoresizingMaskIntoConstraints, false)
  }

  @available(*, deprecated, message: "Use `withAutoLayout.configure()` instead.")
  @discardableResult
  @inlinable
  public func withAutoLayout(configurationHandler: (Self) -> Void) -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    configurationHandler(self)
    return self
  }
}
#endif
