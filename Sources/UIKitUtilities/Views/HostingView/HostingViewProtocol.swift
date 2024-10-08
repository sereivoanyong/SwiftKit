//
//  HostingViewProtocol.swift
//
//  Created by Sereivoan Yong on 12/20/23.
//

import UIKit
import SwiftKit

public protocol HostingViewCell<RootView>: HostingViewProtocol, UIView {

  var contentView: UIView { get }
}

public protocol HostingViewProtocol<RootView>: UIView {

  associatedtype RootView: UIView

  var rootView: RootView! { get set }

  func makeRootView() -> RootView

  /// Called before it is added to `self` or `contentView` (if comform to `HostingCollectionViewCellProtocol` or `HostingTableViewCellProtocol`). Not called if `rootView` is set manually.
  func rootViewDidLoad()

  func rootViewDidMoveToContentView()
}

private var rootViewConstraintsKey: Void?
private var rootViewInsetsKey: Void?
private var rootViewAxesPinningContentViewLayoutMarginsKey: Void?
private var rootViewKey: Void?

extension HostingViewProtocol {

  private var contentView: UIView {
    if let self = self as? any HostingViewCell {
      return self.contentView
    }
    return self
  }

  public var rootViewConstraints: [NSLayoutConstraint] {
    get { return associatedValue(default: [], forKey: &rootViewConstraintsKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &rootViewConstraintsKey, with: self) }
  }

  public var rootViewInsets: DirectionalEdges<CGFloat> {
    get { return associatedValue(default: .zero, forKey: &rootViewInsetsKey, with: self) }
    set {
      setAssociatedValue(newValue, forKey: &rootViewInsetsKey, with: self)
      if rootViewIfLoaded != nil {
        let rootViewConstraints = rootViewConstraints
        rootViewConstraints[0].constant = newValue.top
        rootViewConstraints[1].constant = newValue.leading
        rootViewConstraints[2].constant = newValue.bottom
        rootViewConstraints[3].constant = newValue.trailing
      }
    }
  }

  public var rootViewAxesPinningContentViewLayoutMargins: Axis {
    get { return associatedValue(default: [], forKey: &rootViewAxesPinningContentViewLayoutMarginsKey, with: self) }
    set {
      guard newValue != rootViewAxesPinningContentViewLayoutMargins else { return }
      setAssociatedValue(newValue, forKey: &rootViewAxesPinningContentViewLayoutMarginsKey, with: self)
      if let rootViewIfLoaded {
        reloadConstraints(rootView: rootViewIfLoaded)
      }
    }
  }

  public private(set) var rootViewIfLoaded: RootView? {
    get { return associatedObject(forKey: &rootViewKey, with: self) }
    set { setAssociatedObject(newValue, forKey: &rootViewKey, with: self) }
  }

  public var rootView: RootView! {
    get {
      if let rootViewIfLoaded {
        return rootViewIfLoaded
      }
      let rootView = makeRootView()
      rootViewIfLoaded = rootView
      rootViewDidLoad()
      contentView.addSubview(rootView)
      reloadConstraints(rootView: rootView)
      rootViewDidMoveToContentView()
      return rootView
    }
    set(newRootView) {
      let rootView = rootViewIfLoaded
      if let newRootView {
        rootViewIfLoaded = newRootView
        if newRootView != rootView {
          rootViewConstraints.removeAll()
          rootView?.removeFromSuperview()
        }
        contentView.addSubview(newRootView)
        reloadConstraints(rootView: newRootView)
      } else {
        rootViewIfLoaded = nil
        rootViewConstraints.removeAll()
        rootView?.removeFromSuperview()
      }
    }
  }

  public func makeRootView() -> RootView {
    if let rootViewClass = RootView.self as? (UIView & NibLoadable).Type {
      return rootViewClass.loadFromNib() as! RootView
    } else {
      return RootView()
    }
  }

  public func rootViewDidLoad() {
  }

  public func rootViewDidMoveToContentView() {
  }

  private func reloadConstraints(rootView: RootView) {
    rootView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.deactivate(rootViewConstraints)

    let contentView = contentView
    let axis = rootViewAxesPinningContentViewLayoutMargins
    let insets = rootViewInsets

    let horizontalLayoutGuide: LayoutGuide = axis.contains(.horizontal) ? contentView.layoutMarginsGuide : contentView
    let verticalLayoutGuide: LayoutGuide = axis.contains(.vertical) ? contentView.layoutMarginsGuide : contentView

    let newRootViewContraints = [
      rootView.topAnchor.constraint(equalTo: verticalLayoutGuide.topAnchor, constant: insets.top),
      rootView.leadingAnchor.constraint(equalTo: horizontalLayoutGuide.leadingAnchor, constant: insets.leading),
      verticalLayoutGuide.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: insets.bottom),
      horizontalLayoutGuide.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: insets.trailing)
    ]
    rootViewConstraints = newRootViewContraints
    NSLayoutConstraint.activate(newRootViewContraints)
  }
}

extension HostingViewProtocol where RootView: ContentConfiguring {

  public func configure(_ content: RootView.Content) {
    rootView.configure(content)
  }
}
