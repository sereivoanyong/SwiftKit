//
//  HostingView.swift
//
//  Created by Sereivoan Yong on 10/26/22.
//

import UIKit

public enum RootViewLayoutProvider<RootView: UIView> {

  case pinToSuperview(NSDirectionalEdgeInsets = .zero)

  case pinToSuperviewLayoutMargins(Axis, NSDirectionalEdgeInsets = .zero)

  case custom((RootView, UIView) -> [NSLayoutConstraint])

  public static var `default`: Self {
    return pinToSuperview()
  }

  public func constraints(_ rootView: RootView, targetView: UIView) -> [NSLayoutConstraint] {
    switch self {
    case .pinToSuperview(let insets):
      return [
        rootView.topAnchor.constraint(equalTo: targetView.topAnchor, constant: insets.top),
        rootView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: insets.leading),
        targetView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: insets.bottom),
        targetView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: insets.trailing)
      ]

    case .pinToSuperviewLayoutMargins(let axis, let insets):
      let xAxisLayoutGuide: LayoutGuide = axis.contains(.horizontal) ? targetView.layoutMarginsGuide : targetView
      let yAxisLayoutGuide: LayoutGuide = axis.contains(.vertical) ? targetView.layoutMarginsGuide : targetView
      return [
        rootView.topAnchor.constraint(equalTo: yAxisLayoutGuide.topAnchor, constant: insets.top),
        rootView.leadingAnchor.constraint(equalTo: xAxisLayoutGuide.leadingAnchor, constant: insets.leading),
        yAxisLayoutGuide.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: insets.bottom),
        xAxisLayoutGuide.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: insets.trailing)
      ]

    case .custom(let block):
      return block(rootView, targetView)
    }
  }
}

extension RootViewLayoutProvider: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs, rhs) {
    case (.pinToSuperview(let lhsInsets), .pinToSuperview(let rhsInsets)):
      return lhsInsets == rhsInsets
    case (.pinToSuperviewLayoutMargins(let lhsAxis, let lhsInsets), .pinToSuperviewLayoutMargins(let rhsAxis, let rhsInsets)):
      return lhsAxis == rhsAxis && lhsInsets == rhsInsets
    default:
      return false
    }
  }
}

public protocol HostingViewProtocol<RootView>: UIView {

  associatedtype RootView: UIView

  var rootView: RootView { get set }

  var rootViewLayoutProvider: RootViewLayoutProvider<RootView> { get }

  var targetViewForRootView: UIView { get }
}

private var rootViewKey: Void?
private var rootViewLayoutProviderKey: Void?
private var rootViewConstraintsKey: Void?

extension HostingViewProtocol {

  private var rootViewConstraints: [NSLayoutConstraint] {
    get { return (objc_getAssociatedObject(self, &rootViewConstraintsKey) as? Box<[NSLayoutConstraint]>)?.value ?? [] }
    set { objc_setAssociatedObject(self, &rootViewConstraintsKey, Box(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  private func setRootView(_ rootView: RootView) {
    assert(!rootView.translatesAutoresizingMaskIntoConstraints)
    objc_setAssociatedObject(self, &rootViewKey, rootView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    let targetView = targetViewForRootView
    targetView.addSubview(rootView)
    reloadRootViewConstraints()
  }

  private func reloadRootViewConstraints() {
    NSLayoutConstraint.deactivate(rootViewConstraints)
    rootViewConstraints = rootViewLayoutProvider.constraints(rootView, targetView: targetViewForRootView)
    NSLayoutConstraint.activate(rootViewConstraints)
  }

  public var rootView: RootView {
    get {
      if let rootView = objc_getAssociatedObject(self, &rootViewKey) as? RootView {
        return rootView
      }
      let rootView: RootView
      if let rootViewClass = RootView.self as? (UIView & NibLoadable).Type {
        rootView = rootViewClass.loadFromNib() as! RootView
      } else {
        rootView = RootView()
      }
      setRootView(rootView)
      return rootView
    }
    set(newRootView) {
      let rootView = rootView
      guard newRootView != rootView else {
        return
      }
      rootView.removeFromSuperview()
      rootViewConstraints.removeAll()

      setRootView(newRootView)
    }
  }

  public var rootViewLayoutProvider: RootViewLayoutProvider<RootView> {
    get { return (objc_getAssociatedObject(self, &rootViewLayoutProviderKey) as? Box<RootViewLayoutProvider<RootView>>)?.value ?? .default }
    set {
      let rootViewLayoutProvider = rootViewLayoutProvider
      guard rootViewLayoutProvider != newValue else {
        return
      }
      objc_setAssociatedObject(self, &rootViewLayoutProviderKey, Box(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      reloadRootViewConstraints()
    }
  }

  public var targetViewForRootView: UIView {
    return self
  }
}

open class HostingView<RootView: UIView>: UIView, HostingViewProtocol {

}

open class HostingCollectionViewCell<RootView: UIView>: UICollectionViewCell, HostingViewProtocol {

  public var targetViewForRootView: UIView {
    return contentView
  }
}

open class HostingTableViewCell<RootView: UIView>: UITableViewCell, HostingViewProtocol {

  public var targetViewForRootView: UIView {
    return contentView
  }
}
