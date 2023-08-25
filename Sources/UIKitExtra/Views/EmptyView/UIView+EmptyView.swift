//
//  UIView+EmptyView.swift
//
//  Created by Sereivoan Yong on 4/30/21.
//

#if os(iOS)

import UIKit

extension UIView {

  private static var emptyViewKey: Void?
  final public var emptyView: EmptyView? {
    get {
      return objc_getAssociatedObject(self, &Self.emptyViewKey) as? EmptyView
    }
    set {
      if let oldValue = emptyView {
        oldValue.removeFromSuperview()
      }
      if let newValue = newValue {
        UICollectionView.swizzlingHandler
        UITableView.swizzlingHandler
        assert(newValue.superview == nil)
        newValue.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newValue)

        NSLayoutConstraint.activate([
          newValue.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
          newValue.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
          newValue.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
          newValue.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor)
        ])
      }
      objc_setAssociatedObject(self, &Self.emptyViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UICollectionView {

  fileprivate static let swizzlingHandler: Void = {
    let klass = UICollectionView.self
    class_exchangeInstanceMethodImplementations(klass, #selector(reloadData), #selector(ev_reloadData))
    class_exchangeInstanceMethodImplementations(klass, #selector(performBatchUpdates(_:completion:)), #selector(ev_performBatchUpdates(_:completion:)))
  }()

  @objc private func ev_reloadData() {
    ev_reloadData()
    reloadEmptyViewIfPossible()
  }

  @objc private func ev_performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
    ev_performBatchUpdates(updates, completion: completion)
    reloadEmptyViewIfPossible()
  }
}

extension UITableView {

  fileprivate static let swizzlingHandler: Void = {
    let klass = UITableView.self
    class_exchangeInstanceMethodImplementations(klass, #selector(reloadData), #selector(ev_reloadData))
    if #available(iOS 11.0, *) {
      class_exchangeInstanceMethodImplementations(klass, #selector(performBatchUpdates(_:completion:)), #selector(ev_performBatchUpdates(_:completion:)))
    }
    class_exchangeInstanceMethodImplementations(klass, #selector(endUpdates), #selector(ev_endUpdates))
  }()

  @objc private func ev_reloadData() {
    ev_reloadData()
    reloadEmptyViewIfPossible()
  }

  @available(iOS 11.0, *)
  @objc private func ev_performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
    ev_performBatchUpdates(updates, completion: completion)
    reloadEmptyViewIfPossible()
  }

  @objc private func ev_endUpdates() {
    ev_endUpdates()
    reloadEmptyViewIfPossible()
  }
}

#endif
