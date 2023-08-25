//
//  EdgeAnchors.swift
//
//  Created by Sereivoan Yong on 10/28/22.
//

import UIKit

public struct _EdgeAttributes<OtherAnchors, Constants> {

  public let otherAnchors: OtherAnchors
  public let constants: Constants

  @usableFromInline
  init(otherAnchors: OtherAnchors, constants: Constants) {
    self.otherAnchors = otherAnchors
    self.constants = constants
  }
}

// MARK: DirectionalEdgeConstraints

public typealias DirectionalEdgeConstraints = DirectionalEdges<NSLayoutConstraint>

extension DirectionalAxisEdges where XAxisItem == NSLayoutXAxisAnchor, YAxisItem == NSLayoutYAxisAnchor {

  /// ```
  /// view.directionalAnchors.constraints(equalTo: view2.directionalAnchors, constants: DirectionalEdgeInsets.zero)
  /// ```
  @inlinable
  public func constraints(
    equalTo anchors: Self,
    constants: any DirectionalEdgesProtocol<CGFloat> = DirectionalEdgeInsets.zero
  ) -> DirectionalEdgeConstraints {
    return .init(
      top: top.constraint(equalTo: anchors.top, constant: constants.top),
      leading: leading.constraint(equalTo: anchors.leading, constant: constants.leading),
      bottom: anchors.bottom.constraint(equalTo: bottom, constant: constants.bottom),
      trailing: anchors.trailing.constraint(equalTo: trailing, constant: constants.trailing)
    )
  }

  /// ```
  /// view.directionalAnchors == view2.directionalAnchors
  /// ```
  @inlinable
  public static func == (anchors: Self, otherAnchors: Self) -> DirectionalEdgeConstraints {
    return anchors.constraints(equalTo: otherAnchors)
  }

  @inlinable
  public static func == <Constants: DirectionalEdgesProtocol<CGFloat>>(anchors: Self, attributes: _EdgeAttributes<Self, Constants>) -> DirectionalEdgeConstraints {
    return anchors.constraints(equalTo: attributes.otherAnchors, constants: attributes.constants)
  }

  @inlinable
  public static func + <Constants: DirectionalEdgesProtocol<CGFloat>>(otherAnchors: Self, constants: Constants) -> _EdgeAttributes<Self, Constants> {
    return .init(otherAnchors: otherAnchors, constants: constants)
  }
}

// MARK: EdgeConstraints

public typealias EdgeConstraints = Edges<NSLayoutConstraint>

extension AxisEdges where XAxisItem == NSLayoutXAxisAnchor, YAxisItem == NSLayoutYAxisAnchor {

  /// ```
  /// view.anchors.constraints(equalTo: view2.anchors, constants: EdgeInsets.zero)
  /// ```
  @inlinable
  public func constraints(
    equalTo anchors: Self,
    constants: any EdgesProtocol<CGFloat> = EdgeInsets.zero
  ) -> EdgeConstraints {
    return .init(
      top: top.constraint(equalTo: anchors.top, constant: constants.top),
      left: left.constraint(equalTo: anchors.left, constant: constants.left),
      bottom: anchors.bottom.constraint(equalTo: bottom, constant: constants.bottom),
      right: anchors.right.constraint(equalTo: right, constant: constants.right)
    )
  }

  /// ```
  /// view.anchors == view2.anchors
  /// ```
  @inlinable
  public static func == (anchors: Self, otherAnchors: Self) -> EdgeConstraints {
    return anchors.constraints(equalTo: otherAnchors)
  }

  @inlinable
  public static func == <Constants: EdgesProtocol<CGFloat>>(anchors: Self, attributes: _EdgeAttributes<Self, Constants>) -> EdgeConstraints {
    return anchors.constraints(equalTo: attributes.otherAnchors, constants: attributes.constants)
  }

  @inlinable
  public static func + <Constants: EdgesProtocol<CGFloat>>(otherAnchors: Self, constants: Constants) -> _EdgeAttributes<Self, Constants> {
    return .init(otherAnchors: otherAnchors, constants: constants)
  }
}
