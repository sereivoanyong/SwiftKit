//
//  UIScrollView.swift
//
//  Created by Sereivoan Yong on 10/29/19.
//

#if canImport(UIKit)
import UIKit

extension UIScrollView {
  
  final public func configureForNonScrolling() {
    bounces = false
    alwaysBounceHorizontal = false
    alwaysBounceVertical = false
    isPagingEnabled = false
    isScrollEnabled = false
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
  }
  
  final public func scrollToBottom(animated: Bool = false) {
    let bottomInset: CGFloat
    if #available(iOS 11.0, *) {
      bottomInset = adjustedContentInset.bottom
    } else {
      bottomInset = contentInset.bottom
    }
    setContentOffset(CGPoint(x: 0, y: contentSize.height - bounds.size.height + bottomInset), animated: animated)
  }
  
  /// Returns a snapshot of an entire content of the scroll view
  final public func contentSnapshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
    let context = UIGraphicsGetCurrentContext()!
    let previousFrame = frame
    frame = CGRect(origin: frame.origin, size: contentSize)
    layer.render(in: context)
    frame = previousFrame
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
  public enum ArrangmentSpacing {
    
    case fixed(CGFloat)
    case respective([CGFloat])
    case custom((Int) -> CGFloat)
    
    public func value(at index: Int) -> CGFloat {
      switch self {
      case .fixed(let value):
        return value
      case .respective(let values):
        return values[index]
      case .custom(let provider):
        return provider(index)
      }
    }
  }
  
  @available(iOS 11.0, *)
  @inlinable final public func addArrangedSubviews(_ views: [UIView], alignmentLayoutGuide: LayoutGuide? = nil, spacing: ArrangmentSpacing = .fixed(0.0), insets: UIEdgeInsets = .zero, axis: NSLayoutConstraint.Axis) {
    let alignmentLayoutGuide = alignmentLayoutGuide ?? contentLayoutGuide
    switch axis {
    case .horizontal:
      var lastRightAnchor = contentLayoutGuide.leftAnchor
      for (index, view) in views.enumerated() {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.pinVerticalAnchors(inside: alignmentLayoutGuide, topConstant: insets.top, bottomConstant: insets.bottom)
        view.leftAnchor.equalTo(lastRightAnchor, constant: index > 0 ? spacing.value(at: index - 1) : insets.left)
        lastRightAnchor = view.rightAnchor
      }
      contentLayoutGuide.rightAnchor.equalTo(views.last!.rightAnchor, constant: insets.right)
      contentLayoutGuide.heightAnchor.equalTo(frameLayoutGuide.heightAnchor)
      
    case .vertical:
      var lastBottomAnchor = contentLayoutGuide.topAnchor
      for (index, view) in views.enumerated() {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.pinHorizontalAnchors(inside: alignmentLayoutGuide, leftConstant: insets.left, rightConstant: insets.right)
        view.topAnchor.equalTo(lastBottomAnchor, constant: index > 0 ? spacing.value(at: index - 1) : insets.top)
        lastBottomAnchor = view.bottomAnchor
      }
      contentLayoutGuide.bottomAnchor.equalTo(views.last!.bottomAnchor, constant: insets.bottom)
      contentLayoutGuide.widthAnchor.equalTo(frameLayoutGuide.widthAnchor)
      
    @unknown default:
      fatalError()
    }
  }
  
  @available(iOS 11.0, *)
  final public func addContentView(_ contentView: UIView, insets: UIEdgeInsets = .zero, axis: NSLayoutConstraint.Axis) {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentView)
    
    var constraints: [NSLayoutConstraint] = [
      contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: insets.top),
      contentView.leftAnchor.constraint(equalTo: contentLayoutGuide.leftAnchor, constant: insets.left),
      contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: insets.bottom),
      contentLayoutGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: insets.right),
    ]
    switch axis {
    case .horizontal:
      constraints.append(contentLayoutGuide.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor))
    case .vertical:
      constraints.append(contentLayoutGuide.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor))
    @unknown default:
      fatalError()
    }
    NSLayoutConstraint.activate(constraints)
  }
  
  private static var accessoryViewKey: Void?
  @available(iOS 11.0, *)
  final public var accessoryView: UIView? {
    return associatedObject(forKey: &Self.accessoryViewKey)
  }
  
  @available(iOS 11.0, *)
  final public func setAccessoryView(_ accessoryView: UIView, alignmentLayoutGuide: LayoutGuide? = nil, preferredHeight: CGFloat, insets: UIEdgeInsets = .zero) {
    setAssociatedObject(accessoryView, forKey: &Self.accessoryViewKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    addSubview(accessoryView)
    
    contentInset.top = preferredHeight + insets.vertical
    scrollIndicatorInsets.top = contentInset.top
    
    let alignmentLayoutGuide = alignmentLayoutGuide ?? frameLayoutGuide
    NSLayoutConstraint.activate([
      accessoryView.heightAnchor.constraint(equalToConstant: preferredHeight),
      accessoryView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
      accessoryView.leftAnchor.constraint(equalTo: alignmentLayoutGuide.leftAnchor),
      alignmentLayoutGuide.rightAnchor.constraint(equalTo: accessoryView.rightAnchor),
      contentLayoutGuide.topAnchor.constraint(lessThanOrEqualTo: accessoryView.bottomAnchor, constant: insets.bottom),
    ])
  }

  // Swizzle for functionalities

  private static let swizzlingHandler: Void = {
    let klass = UIScrollView.self
    class_exchangeInstanceMethodImplementations(klass, #selector(layoutSubviews), #selector(_layoutSubviews))
    class_exchangeInstanceMethodImplementations(klass, #selector(getter: intrinsicContentSize), #selector(_intrinsicContentSize))
    class_exchangeInstanceMethodImplementations(klass, #selector(setter: contentSize), #selector(_setContentSize(_:)))
  }()

  private static var usesContentSizeAsIntrinsicKey: Void?

  /// A `Bool` value that determines whether the scroll view uses its `contentSize` for `intrinsicContentSize`.
  final public var usesContentSizeAsIntrinsic: Bool {
    get { associatedValue(forKey: &Self.usesContentSizeAsIntrinsicKey) ?? false }
    set { _ = Self.swizzlingHandler; setAssociatedValue(newValue, forKey: &Self.usesContentSizeAsIntrinsicKey) }
  }

  @objc private func _layoutSubviews() {
    _layoutSubviews()

    if usesContentSizeAsIntrinsic && bounds.size != intrinsicContentSize {
      invalidateIntrinsicContentSize()
    }
  }

  @objc private func _intrinsicContentSize() -> CGSize {
    if usesContentSizeAsIntrinsic {
      return contentSize
    }
    return _intrinsicContentSize()
  }

  @objc private func _setContentSize(_ newContentSize: CGSize) {
    if usesContentSizeAsIntrinsic {
      let oldContentSize = contentSize
      _setContentSize(newContentSize)
      if newContentSize != oldContentSize {
        invalidateIntrinsicContentSize()
      }
      return
    }
    _setContentSize(newContentSize)
  }
}
#endif
