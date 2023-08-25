//
//  Edges+Anchors.swift
//
//  Created by Sereivoan Yong on 10/21/22.
//

import UIKit

// MARK: DirectionalXAxisEdgeConstraints

extension DirectionalXAxisEdges where XAxisItem == NSLayoutXAxisAnchor {

  /// ```
  /// view.directionalXAnchors.constraints(equalTo: view2.directionalXAnchors, constants: DirectionalEdgeInsets.zero)
  /// view.directionalXAnchors.constraints(equalTo: view2.directionalAnchors, constants: XAxisEdges<CGFloat>.zero)
  /// ```
  @inlinable
  public func constraints(
    equalTo anchors: any DirectionalXAxisEdgesProtocol<NSLayoutXAxisAnchor>,
    constants: any DirectionalXAxisEdgesProtocol<CGFloat> = DirectionalXAxisEdges<CGFloat>.zero
  ) -> DirectionalXAxisEdges<NSLayoutConstraint> {
    return .init(
      leading: leading.constraint(equalTo: anchors.leading, constant: constants.leading),
      trailing: anchors.trailing.constraint(equalTo: trailing, constant: constants.trailing)
    )
  }

  /// ```
  /// view.directionalXAnchors == view2.directionalXAnchors
  /// ```
  @inlinable
  public static func == (anchors: Self, otherAnchors: any DirectionalXAxisEdgesProtocol<XAxisItem>) -> DirectionalXAxisEdges<NSLayoutConstraint> {
    return anchors.constraints(equalTo: otherAnchors)
  }

  @inlinable
  public static func == <Constants: DirectionalXAxisEdgesProtocol<CGFloat>>(anchors: Self, attributes: _EdgeAttributes<Self, Constants>) -> DirectionalXAxisEdges<NSLayoutConstraint> {
    return anchors.constraints(equalTo: attributes.otherAnchors, constants: attributes.constants)
  }

  @inlinable
  public static func + <Constants: DirectionalXAxisEdgesProtocol<CGFloat>>(otherAnchors: Self, constants: Constants) -> _EdgeAttributes<Self, Constants> {
    return .init(otherAnchors: otherAnchors, constants: constants)
  }
}

// MARK: XAxisEdgeConstraints

extension XAxisEdges where XAxisItem == NSLayoutXAxisAnchor {

  /// ```
  /// view.xAnchors.constraints(equalTo: view2.xAnchors, constants: XAxisEdges<CGFloat>.zero)
  /// view.xAnchors.constraints(equalTo: view2.anchors, constants: XAxisEdges<CGFloat>.zero)
  /// ```
  @inlinable
  public func constraints(
    equalTo anchors: any XAxisEdgesProtocol<NSLayoutXAxisAnchor>,
    constants: any XAxisEdgesProtocol<CGFloat> = XAxisEdges<CGFloat>.zero
  ) -> XAxisEdges<NSLayoutConstraint> {
    return .init(
      left: left.constraint(equalTo: anchors.left, constant: constants.left),
      right: anchors.right.constraint(equalTo: right, constant: constants.right)
    )
  }

  /// ```
  /// view.xAnchors == view2.xAnchors
  /// ```
  @inlinable
  public static func == (anchors: Self, otherAnchors: Self) -> XAxisEdges<NSLayoutConstraint> {
    return anchors.constraints(equalTo: otherAnchors)
  }

  @inlinable
  public static func == <Constants: XAxisEdgesProtocol<CGFloat>>(anchors: Self, attributes: _EdgeAttributes<Self, Constants>) -> XAxisEdges<NSLayoutConstraint> {
    return anchors.constraints(equalTo: attributes.otherAnchors, constants: attributes.constants)
  }

  @inlinable
  public static func + <Constants: XAxisEdgesProtocol<CGFloat>>(otherAnchors: Self, constants: Constants) -> _EdgeAttributes<Self, Constants> {
    return .init(otherAnchors: otherAnchors, constants: constants)
  }
}

// MARK: YAxisEdgeConstraints

extension YAxisEdges where YAxisItem == NSLayoutYAxisAnchor {

  /// ```
  /// view.yAnchors.constraints(equalTo: view2.yAnchors, constants: YAxisEdges<CGFloat>.zero)
  /// view.yAnchors.constraints(equalTo: view2.anchors, constants: YAxisEdges<CGFloat>.zero)
  /// ```
  @inlinable
  public func constraints(
    equalTo anchors: any YAxisEdgesProtocol<NSLayoutYAxisAnchor>,
    constants: any YAxisEdgesProtocol<CGFloat> = YAxisEdges<CGFloat>.zero
  ) -> YAxisEdges<NSLayoutConstraint> {
    return .init(
      top: top.constraint(equalTo: anchors.top, constant: constants.top),
      bottom: anchors.bottom.constraint(equalTo: bottom, constant: constants.bottom)
    )
  }

  /// ```
  /// view.yAnchors == view2.yAnchors
  /// ```
  @inlinable
  public static func == (anchors: Self, otherAnchors: Self) -> YAxisEdges<NSLayoutConstraint> {
    return anchors.constraints(equalTo: otherAnchors)
  }

  @inlinable
  public static func == <Constants: YAxisEdgesProtocol<CGFloat>>(anchors: Self, attributes: _EdgeAttributes<Self, Constants>) -> YAxisEdges<NSLayoutConstraint> {
    return anchors.constraints(equalTo: attributes.otherAnchors, constants: attributes.constants)
  }

  @inlinable
  public static func + <Constants: YAxisEdgesProtocol<CGFloat>>(otherAnchors: Self, constants: Constants) -> _EdgeAttributes<Self, Constants> {
    return .init(otherAnchors: otherAnchors, constants: constants)
  }
}
