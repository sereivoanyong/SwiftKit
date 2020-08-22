//
//  ShadowedView.swift
//
//  Created by Sereivoan Yong on 8/22/20.
//

#if canImport(UIKit)
import UIKit

public protocol ShadowedView: AnyObject {
  
  var shadowView: UIView? { get }
}

extension ShadowedView where Self: UIView {
  
  public var shadowView: UIView? {
    return value(forKey: "_shadowView") as? UIView
  }
}

public protocol ShadowedViewHideable: AnyObject {
  
  var hidesShadow: Bool { get set }
}

extension ShadowedViewHideable where Self: UIView {
  
  public var hidesShadow: Bool {
    get { value(forKey: "_hidesShadow") as? Bool ?? false }
    set { setValue(newValue, forKey: "_hidesShadow") }
  }
}

extension UINavigationBar: ShadowedViewHideable { }
extension UITabBar: ShadowedView & ShadowedViewHideable { }
extension UIToolbar: ShadowedView & ShadowedViewHideable { }
extension UISearchBar: ShadowedView { }
#endif
