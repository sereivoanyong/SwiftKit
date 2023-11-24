//
//  HostingView.swift
//
//  Created by Sereivoan Yong on 10/26/22.
//

import UIKit

public protocol HostingViewProtocol<RootView>: UIView {

  associatedtype RootView: UIView

  var rootView: RootView! { get set }

  var contentView: UIView { get }
}

private var rootViewConstraintsKey: Void?
private var rootViewInsetsKey: Void?
private var rootViewAxesPinningContentViewLayoutMarginsKey: Void?
private var rootViewKey: Void?

extension HostingViewProtocol {

  public var rootViewConstraints: [NSLayoutConstraint] {
    get { return associatedValue(default: [], forKey: &rootViewConstraintsKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &rootViewConstraintsKey, with: self) }
  }

  public var rootViewInsets: DirectionalEdges<CGFloat> {
    get {
      return associatedValue(default: .zero, forKey: &rootViewInsetsKey, with: self)
    }
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
    get {
      return associatedValue(default: [], forKey: &rootViewAxesPinningContentViewLayoutMarginsKey, with: self)
    }
    set {
      guard newValue != rootViewAxesPinningContentViewLayoutMargins else { return }
      setAssociatedValue(newValue, forKey: &rootViewAxesPinningContentViewLayoutMarginsKey, with: self)
      if rootViewIfLoaded != nil {
        reloadRootViewConstraints()
      }
    }
  }

  public var rootViewIfLoaded: RootView? {
    return associatedObject(forKey: &rootViewKey, with: self)
  }

  public var rootView: RootView! {
    get {
      if let rootView = rootViewIfLoaded {
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
      setRootView(newRootView)
    }
  }

  private func setRootView(_ newRootView: RootView?) {
    let rootView = rootViewIfLoaded
    if let newRootView {
      if newRootView != rootView {
        rootView?.removeFromSuperview()
        rootViewConstraints.removeAll()
      }
      assert(!newRootView.translatesAutoresizingMaskIntoConstraints)
      contentView.addSubview(newRootView)

      setAssociatedObject(newRootView, forKey: &rootViewKey, with: self)
      reloadRootViewConstraints()
    } else {
      rootView?.removeFromSuperview()
      rootViewConstraints.removeAll()
    }
  }

  private func reloadRootViewConstraints() {
    guard let rootView else { return }
    NSLayoutConstraint.deactivate(rootViewConstraints)

    let insets = rootViewInsets
    let axis = rootViewAxesPinningContentViewLayoutMargins
    let contentView = contentView

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

  public var contentView: UIView {
    return self
  }
}

open class HostingView<RootView: UIView>: UIView, HostingViewProtocol {

}

open class HostingCollectionViewCell<RootView: UIView>: UICollectionViewCell, HostingViewProtocol {

}

// This cell is supposed to fill its container width
@available(iOS 14.0, *)
open class HostingCollectionViewListCell<RootView: UIView>: UICollectionViewListCell, HostingViewProtocol {

  open var isSeparatorConfigured: Bool = false

  public override init(frame: CGRect) {
    super.init(frame: frame)

    preservesSuperviewLayoutMargins = true
    contentView.preservesSuperviewLayoutMargins = true
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

open class HostingTableViewCell<RootView: UIView>: UITableViewCell, HostingViewProtocol {

}

extension HostingViewProtocol where RootView: ContentConfiguring {

  public func configure(_ content: RootView.Content) {
    rootView.configure(content)
  }
}

extension HostingView: ContentConfiguring where RootView: ContentConfiguring { }

extension HostingCollectionViewCell: ContentConfiguring where RootView: ContentConfiguring { }

@available(iOS 14.0, *)
extension HostingCollectionViewListCell: ContentConfiguring where RootView: ContentConfiguring { }

extension HostingTableViewCell: ContentConfiguring where RootView: ContentConfiguring { }
