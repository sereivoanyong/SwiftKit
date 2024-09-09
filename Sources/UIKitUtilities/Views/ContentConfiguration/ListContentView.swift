//
//  ListContentView.swift
//
//  Created by Sereivoan Yong on 9/19/22.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
public protocol ListContentView: UIView, UIContentView {

  var primaryContentAnchorsForSeparator: (leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor) { get }
}

private var separatorViewKey: Void?

@available(iOS 14.0, *)
extension ListContentView {

  public var primaryContentAnchorsForSeparator: (leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor) {
    return (layoutMarginsGuide.leadingAnchor, layoutMarginsGuide.trailingAnchor)
  }

  public var showsSeparator: Bool {
    get {
      if let separatorViewIfLoaded {
        return !separatorViewIfLoaded.isHidden
      }
      return false
    }
    set {
      if newValue {
        separatorView.isHidden = !newValue
      } else {
        separatorViewIfLoaded?.isHidden = !newValue
      }
    }
  }

  public var separatorViewIfLoaded: SeparatorView? {
    return associatedObject(forKey: &separatorViewKey, with: self)
  }

  public var separatorView: SeparatorView {
    if let separatorView = associatedObject(forKey: &separatorViewKey, with: self) as SeparatorView? {
      return separatorView
    }
    let separatorView = SeparatorView()
    setAssociatedObject(separatorView, forKey: &separatorViewKey, with: self)
    separatorView.isHidden = true
    insertSubview(separatorView, at: 0)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.leadingAnchor.constraint(equalTo: primaryContentAnchorsForSeparator.leading),
      primaryContentAnchorsForSeparator.trailing.constraint(equalTo: separatorView.trailingAnchor),
      bottomAnchor.constraint(equalTo: separatorView.bottomAnchor)
    ])
    return separatorView
  }
}
