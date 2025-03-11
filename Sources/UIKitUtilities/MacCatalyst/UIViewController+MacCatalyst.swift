//
//  UIViewController+MacCatalyst.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/11/25.
//

import UIKit
import SwiftKit

#if targetEnvironment(macCatalyst)

@available(iOS 13.0, macCatalyst 13.1, *)
extension UIScene {

  private static var itemTitleObservationKey: Void?
  private var itemTitleObservation: NSKeyValueObservation? {
    get { return associatedObject(forKey: &Self.itemTitleObservationKey, with: self) }
    set { setAssociatedObject(newValue, forKey: &Self.itemTitleObservationKey, with: self) }
  }

  private static var itemKey: Void?
  weak public var item: SceneItem? {
    get { return associatedObject(forKey: &Self.itemKey, with: self) }
    set(newItem) {
      setAssociatedObject(newItem, forKey: &Self.itemKey, with: self)
      itemTitleObservation = newItem?.observe(\.title, options: [.initial, .new]) { [weak self] newItem, _ in
        self?.title = newItem.title
      }
    }
  }
}

extension UIViewController {

  private static var sceneItemKey: Void?
  public var sceneItem: SceneItem! {
    get {
      if let item = associatedObject(forKey: &Self.sceneItemKey, with: self) as SceneItem? {
        return item
      }
      let item = SceneItem()
      item.viewController = self
      setAssociatedObject(item, forKey: &Self.sceneItemKey, with: self)
      return item
    }
    set {
      setAssociatedObject(newValue, forKey: &Self.sceneItemKey, with: self)
    }
  }
}

// MARK: TopViewControllerForScene Finding

extension UIViewController {

  @objc var topViewControllerForScene: UIViewController? {
    return nil
  }
}

extension UINavigationController {

  override var topViewControllerForScene: UIViewController? {
    return topViewController?.topViewControllerForScene ?? topViewController
  }
}

extension UITabBarController {

  override var topViewControllerForScene: UIViewController? {
    return selectedViewController?.topViewControllerForScene ?? selectedViewController
  }
}

// MARK: Scene Finding

extension UIResponder {

  @available(iOS 13.0, macCatalyst 13.1, *)
  @objc var scene: UIScene? {
    return nil
  }
}

@available(iOS 13.0, macCatalyst 13.1, *)
extension UIScene {

  @objc override var scene: UIScene? {
    return self
  }
}

extension UIView {

  @available(iOS 13.0, macCatalyst 13.1, *)
  @objc override var scene: UIScene? {
    if let window {
      return window.windowScene
    } else {
      return next?.scene
    }
  }
}

extension UIViewController {

  // Accessed by NavigationController, TabBarControll & SplitViewController to update item
  @available(iOS 13.0, macCatalyst 13.1, *)
  @objc override var scene: UIScene? {
    // Try walking the responder chain
    var result = next?.scene
    if result == nil {
      // That didn't work. Try asking my parent view controller
      result = parent?.scene
    }
    if result == nil {
      // That didn't work. Try asking my presenting view controller
      result = presentingViewController?.scene
    }
    return result
  }
}

#endif
