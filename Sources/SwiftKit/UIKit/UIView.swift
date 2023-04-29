//
//  UIView.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

extension UIView {

  public var owningViewController: UIViewController? {
    if let next {
      if let viewController = next as? UIViewController {
        return viewController
      }
      if let view = next as? UIView {
        return view.owningViewController
      }
    }
    return nil
  }

  public func viewToResepectLayoutMargins() -> UIView {
    if preservesSuperviewLayoutMargins, let superview {
      return superview.viewToResepectLayoutMargins()
    }
    return self
  }

  /// Returns a snapshot of an entire bounds of the view
  public func snapshot() -> UIImage {
    return UIImage(size: bounds.size, opaque: false, scale: traitCollection.displayScale, actions: layer.render(in:))
  }

  public func sizeThatFits(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
    return sizeThatFits(CGSize(width: width, height: height))
  }

  public var readableContentFrame: CGRect {
    return readableContentGuide.layoutFrame
  }

  public var readableContentInsets: UIEdgeInsets {
    let frame = readableContentGuide.layoutFrame
    return UIEdgeInsets(top: frame.minY, left: frame.minX, bottom: bounds.height - frame.maxY, right: bounds.width - frame.maxX)
  }

  public func addSubviews(_ views: [UIView]) {
    for view in views {
      addSubview(view)
    }
  }

  public func removeSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }

  @discardableResult
  public func addTapGestureRecognizer(handler: @escaping (UITapGestureRecognizer) -> Void, configurationHandler: (UITapGestureRecognizer) -> Void = { _ in }) -> UITapGestureRecognizer {
    isUserInteractionEnabled = true
    let tapGestureRecognizer = UITapGestureRecognizer(handler: handler)
    tapGestureRecognizer.cancelsTouchesInView = false
    configurationHandler(tapGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    return tapGestureRecognizer
  }

  @discardableResult
  public func addTapGestureRecognizerToEndEditing(_ force: Bool = true) -> UITapGestureRecognizer {
    return addTapGestureRecognizer { [unowned self] _ in
      endEditing(force)
    }
  }

  /// Sets the priority with which a view resists being made larger or smaller than its intrinsic size
  public func setContentResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
    setContentHuggingPriority(priority, for: axis)
    setContentCompressionResistancePriority(priority, for: axis)
  }
  
  /// Sets the priority with which a view resists being made larger or smaller than its intrinsic size
  public func setContentResistancePriority(_ priority: UILayoutPriority) {
    setContentResistancePriority(priority, for: .horizontal)
    setContentResistancePriority(priority, for: .vertical)
  }

  public func resolveColor(_ color: UIColor?, from traitCollection: UITraitCollection) -> UIColor {
    let color = color ?? tintColor ?? .systemBlue
    if #available(iOS 13.0, *) {
      switch overrideUserInterfaceStyle {
      case .unspecified:
        return color.resolvedColor(with: traitCollection)
      default:
        return color.resolvedColor(with: UITraitCollection(userInterfaceStyle: overrideUserInterfaceStyle))
      }
    } else {
      return color
    }
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
    return with(\.translatesAutoresizingMaskIntoConstraints, false)
  }
}
#endif
