//
//  UIView.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

extension UIView {
  
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
  
  final public func addSubviews(_ views: UIView...) {
    for view in views {
      addSubview(view)
    }
  }
  
  final public func addTapGestureRecognizerToEndEditing() {
    addGestureRecognizer(UITapGestureRecognizer(handler: { [unowned self] _ in
      self.endEditing(true)
    }))
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
  
  @inlinable public var withAutoLayout: Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }
  
  @discardableResult
  @inlinable public func withAutoLayout(configurationHandler: (Self) -> Void) -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    configurationHandler(self)
    return self
  }
  
  @discardableResult
  @inlinable public func with<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>, _ value: Value) -> Self {
    self[keyPath: keyPath] = value
    return self
  }
  
  @discardableResult
  @inlinable public func with(_ keyPath: ReferenceWritableKeyPath<Self, UIEdgeInsets>, top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
    return with(keyPath, UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
  }
  
  @discardableResult
  @inlinable public func with(_ keyPath: ReferenceWritableKeyPath<Self, UIFont>, size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
    return with(keyPath, .systemFont(ofSize: size, weight: weight))
  }
}

extension UIView {
  
  func addStackLayoutGuide(_ views: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: CGFloat = 0, insets: UIEdgeInsets = .zero) -> UILayoutGuide {
    addSubviews(views)
    
    let layoutGuide = UILayoutGuide()
    addLayoutGuide(layoutGuide)
    
    layoutGuide.stack(views, axis: axis, distribution: distribution, alignment: alignment, spacing: spacing, insets: insets)
    return layoutGuide
  }
}

extension LayoutGuide {
  
  func stack(_ views: [LayoutGuide], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: CGFloat = 0, insets: UIEdgeInsets = .zero) {
    switch axis {
    case .horizontal:
      var constraints: [NSLayoutConstraint] = []
      
      precondition(distribution == .fillProportionally)
      var lastLayout: (anchor: NSLayoutXAxisAnchor, spacing: CGFloat) = (leftAnchor, insets.left)
      for view in views {
        constraints += view.leftAnchor.constraint(equalTo: lastLayout.anchor, constant: lastLayout.spacing)
        lastLayout = (view.rightAnchor, spacing)
      }
      constraints += rightAnchor.constraint(equalTo: lastLayout.anchor, constant: insets.right)
      
      precondition(alignment == .fill)
      for view in views {
        constraints += view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        constraints += bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
      }
      
      NSLayoutConstraint.activate(constraints)
      
    default:
      fatalError()
    }
  }
}
#endif
