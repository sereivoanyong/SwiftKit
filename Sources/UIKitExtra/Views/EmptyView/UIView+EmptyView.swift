//
//  UIView+EmptyView.swift
//
//  Created by Sereivoan Yong on 4/30/21.
//

import UIKit
import SwiftKit

extension UIView {

  private static var emptyViewKey: Void?
  public var emptyView: EmptyView? {
    get {
      return associatedObject(forKey: &Self.emptyViewKey, with: self)
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
      setAssociatedObject(newValue, forKey: &Self.emptyViewKey, with: self)
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
    class_exchangeInstanceMethodImplementations(klass, #selector(performBatchUpdates(_:completion:)), #selector(ev_performBatchUpdates(_:completion:)))
    class_exchangeInstanceMethodImplementations(klass, #selector(endUpdates), #selector(ev_endUpdates))
  }()

  @objc private func ev_reloadData() {
    ev_reloadData()
    reloadEmptyViewIfPossible()
  }

  @objc private func ev_performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
    ev_performBatchUpdates(updates, completion: completion)
    reloadEmptyViewIfPossible()
  }

  @objc private func ev_endUpdates() {
    ev_endUpdates()
    reloadEmptyViewIfPossible()
  }
}
