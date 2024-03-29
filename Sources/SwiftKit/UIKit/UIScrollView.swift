//
//  UIScrollView.swift
//
//  Created by Sereivoan Yong on 10/29/19.
//

import UIKit

extension UIScrollView {

  public func configureForNonScrolling() {
    bounces = false
    alwaysBounceHorizontal = false
    alwaysBounceVertical = false
    isPagingEnabled = false
    isScrollEnabled = false
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
  }

  public func scrollToBottom(animated: Bool = false) {
    setContentOffset(CGPoint(x: 0, y: contentSize.height - bounds.size.height + adjustedContentInset.bottom), animated: animated)
  }

  /// Returns a snapshot of an entire content of the scroll view
  public func contentSnapshot() -> UIImage? {
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

  @inlinable
  public func addArrangedSubviews(_ views: [UIView], alignmentLayoutGuide: LayoutGuide? = nil, spacing: ArrangmentSpacing = .fixed(0.0), insets: UIEdgeInsets = .zero, axis: NSLayoutConstraint.Axis) {
    let alignmentLayoutGuide = alignmentLayoutGuide ?? contentLayoutGuide
    switch axis {
    case .horizontal:
      var lastRightAnchor = contentLayoutGuide.leftAnchor
      for (index, view) in views.enumerated() {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        NSLayoutConstraint.activate([
          view.topAnchor.constraint(equalTo: alignmentLayoutGuide.topAnchor, constant: insets.top),
          alignmentLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),

          view.leftAnchor.constraint(equalTo: lastRightAnchor, constant: index > 0 ? spacing.value(at: index - 1) : insets.left)
        ])
        lastRightAnchor = view.rightAnchor
      }
      contentLayoutGuide.rightAnchor.equalTo(views.last!.rightAnchor, constant: insets.right)
      contentLayoutGuide.heightAnchor.equalTo(frameLayoutGuide.heightAnchor)

    case .vertical:
      var lastBottomAnchor = contentLayoutGuide.topAnchor
      for (index, view) in views.enumerated() {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        NSLayoutConstraint.activate([
          view.leftAnchor.constraint(equalTo: alignmentLayoutGuide.leftAnchor, constant: insets.left),
          alignmentLayoutGuide.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right),

          view.topAnchor.constraint(equalTo: lastBottomAnchor, constant: index > 0 ? spacing.value(at: index - 1) : insets.top)
        ])
        lastBottomAnchor = view.bottomAnchor
      }
      contentLayoutGuide.bottomAnchor.equalTo(views.last!.bottomAnchor, constant: insets.bottom)
      contentLayoutGuide.widthAnchor.equalTo(frameLayoutGuide.widthAnchor)

    @unknown default:
      fatalError()
    }
  }

  public func addContentView(_ contentView: UIView, insets: UIEdgeInsets = .zero, axis: NSLayoutConstraint.Axis) {
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
  public var accessoryView: UIView? {
    return associatedObject(forKey: &Self.accessoryViewKey, with: self)
  }

  public func setAccessoryView(_ accessoryView: UIView, alignmentLayoutGuide: LayoutGuide? = nil, preferredHeight: CGFloat, insets: UIEdgeInsets = .zero) {
    setAssociatedObject(accessoryView, forKey: &Self.accessoryViewKey,with: self)
    addSubview(accessoryView)

    contentInset.top = preferredHeight + insets.top + insets.bottom
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
    class_exchangeInstanceMethodImplementations(klass, #selector(layoutSubviews), #selector(_sk_sv_layoutSubviews))
    class_exchangeInstanceMethodImplementations(klass, #selector(getter: intrinsicContentSize), #selector(_sk_sv_intrinsicContentSize))
    class_exchangeInstanceMethodImplementations(klass, #selector(setter: contentSize), #selector(_sk_sv_setContentSize(_:)))
  }()

  private static var usesContentSizeAsIntrinsicKey: Void?

  /// A `Bool` value that determines whether the scroll view uses its `contentSize` for `intrinsicContentSize`.
  public var usesContentSizeAsIntrinsic: Bool {
    get { return associatedValue(forKey: &Self.usesContentSizeAsIntrinsicKey, with: self) ?? false }
    set {
      _ = Self.swizzlingHandler;
      setAssociatedValue(newValue, forKey: &Self.usesContentSizeAsIntrinsicKey, with: self)
    }
  }

  @objc private func _sk_sv_layoutSubviews() {
    _sk_sv_layoutSubviews()

    if usesContentSizeAsIntrinsic && bounds.size != intrinsicContentSize {
      invalidateIntrinsicContentSize()
    }
  }

  @objc private func _sk_sv_intrinsicContentSize() -> CGSize {
    if usesContentSizeAsIntrinsic {
      return contentSize
    }
    return _sk_sv_intrinsicContentSize()
  }

  @objc private func _sk_sv_setContentSize(_ newContentSize: CGSize) {
    if usesContentSizeAsIntrinsic {
      let oldContentSize = contentSize
      _sk_sv_setContentSize(newContentSize)
      if newContentSize != oldContentSize {
        invalidateIntrinsicContentSize()
      }
      return
    }
    _sk_sv_setContentSize(newContentSize)
  }
}
