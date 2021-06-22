//
//  LayoutGuide.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

public protocol LayoutGuide: AnyObject {

  var leadingAnchor: NSLayoutXAxisAnchor { get }
  var trailingAnchor: NSLayoutXAxisAnchor { get }
  var leftAnchor: NSLayoutXAxisAnchor { get }
  var rightAnchor: NSLayoutXAxisAnchor { get }
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }
  var widthAnchor: NSLayoutDimension { get }
  var heightAnchor: NSLayoutDimension { get }
  var centerXAnchor: NSLayoutXAxisAnchor { get }
  var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuide { }
extension UILayoutGuide: LayoutGuide { }
#endif
