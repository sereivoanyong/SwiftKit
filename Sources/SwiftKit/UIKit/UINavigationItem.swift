//
//  UINavigationItem.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(UIKit)
import UIKit

// @see: https://stackoverflow.com/a/34343418
extension UINavigationItem {
  
  public var attributedTitle: NSAttributedString? {
    get {
      return (titleView as? UILabel)?.attributedText
    }
    set {
      guard let newValue, newValue != attributedTitle else {
        if titleView is UILabel {
          titleView = nil
        }
        return
      }
      let titleLabel: UILabel
      if let label = titleView as? UILabel {
        titleLabel = label
      } else {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        titleView = label
        titleLabel = label
      }
      titleLabel.attributedText = newValue
      titleLabel.sizeToFit()
    }
  }
  
  public var isBackgroundHidden: Bool {
    get { return value(forKey: "backgroundHidden") as? Bool ?? false }
    set { setValue(newValue as NSNumber, forKey: "backgroundHidden") }
  }
  
  public func removeBackButtonTitle() {
    if #available(iOS 14.0, *) {
      backButtonDisplayMode = .minimal
    } else if #available(iOS 11.0, *) {
      backButtonTitle = ""
    } else {
      backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
  }
  
  static private var shouldPopKey: Void?
  public var shouldPopHandler: (() -> Bool)? {
    get { return associatedValue(forKey: &UINavigationItem.shouldPopKey) as (() -> Bool)? }
    set { setAssociatedValue(newValue, forKey: &UINavigationItem.shouldPopKey) }
  }
}
#endif
