//
//  LayoutGuide.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

import UIKit

public typealias DirectionalXAxisEdgeAnchors = DirectionalXAxisEdges<NSLayoutXAxisAnchor>

public typealias XAxisEdgeAnchors = XAxisEdges<NSLayoutXAxisAnchor>

public typealias YAxisEdgeAnchors = YAxisEdges<NSLayoutYAxisAnchor>

public typealias DirectionalEdgeAnchors = DirectionalAxisEdges<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor>

public typealias EdgeAnchors = AxisEdges<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor>

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
  var superLayoutGuide: LayoutGuide? { get }
}

extension LayoutGuide {

  /// Layout anchors representing the leading and trailing of the guide’s frame.
  public var directionalXAnchors: DirectionalXAxisEdgeAnchors {
    return .init(leading: leadingAnchor, trailing: trailingAnchor)
  }

  /// Layout anchors representing the left and right of the guide’s frame.
  public var xAnchors: XAxisEdgeAnchors {
    return .init(left: leftAnchor, right: rightAnchor)
  }

  /// Layout anchors representing the top and bottom of the guide’s frame.
  public var yAnchors: YAxisEdgeAnchors {
    return .init(top: topAnchor, bottom: bottomAnchor)
  }

  /// Layout anchors representing the top, leading, bottom and trailing of the guide’s frame.
  public var directionalAnchors: DirectionalEdgeAnchors {
    return .init(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
  }

  /// Layout anchors representing the top, left, bottom and right of the guide’s frame.
  public var anchors: EdgeAnchors {
    return .init(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
  }
}

extension UIView: LayoutGuide {

  public var superLayoutGuide: LayoutGuide? {
    return superview
  }
}

extension UILayoutGuide: LayoutGuide {

  public var superLayoutGuide: LayoutGuide? {
    return owningView
  }
}
