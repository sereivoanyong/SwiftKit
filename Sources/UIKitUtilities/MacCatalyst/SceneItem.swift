//
//  SceneItem.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/13/25.
//

import UIKit
import SwiftKit

#if targetEnvironment(macCatalyst)

open class SceneItem: NSObject {

  private var _title: String?
  @objc open var title: String! {
    get { return _title ?? viewController?.title }
    set {
      willChangeValue(for: \.title)
      _title = newValue
      didChangeValue(for: \.title)
      reloadViewControllerTitleObservation()
    }
  }

  weak var viewController: UIViewController? {
    willSet {
      if _title == nil {
        willChangeValue(for: \.title)
      }
    }
    didSet {
      if _title == nil {
        didChangeValue(for: \.title)
      }
      reloadViewControllerTitleObservation()
    }
  }

  private var viewControllerTitleObservation: NSKeyValueObservation?
  private func reloadViewControllerTitleObservation() {
    guard _title == nil else {
      viewControllerTitleObservation = nil
      return
    }
    viewControllerTitleObservation = viewController?.observe(\.title, options: [.new]) { [unowned self] viewController, _ in
      willChangeValue(for: \.title)
      didChangeValue(for: \.title)
    }
  }
}
#endif
