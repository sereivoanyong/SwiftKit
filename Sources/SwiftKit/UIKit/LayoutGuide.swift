//
//  LayoutGuide.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

public typealias NSLayoutCenterConstraints = (x: NSLayoutConstraint, y: NSLayoutConstraint)
public typealias NSLayoutXAxisConstraints = (left: NSLayoutConstraint, right: NSLayoutConstraint)
public typealias NSLayoutYAxisConstraints = (top: NSLayoutConstraint, bottom: NSLayoutConstraint)
public typealias NSLayoutConstraints = Edges<NSLayoutConstraint>
public typealias NSDirectionalLayoutConstraints = DirectionalEdges<NSLayoutConstraint>

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

extension LayoutGuide {
  
  @discardableResult
  public func pinCenterAnchors(inside container: LayoutGuide, xConstant: CGFloat = 0, yConstant: CGFloat = 0) -> NSLayoutCenterConstraints {
    return (
      centerXAnchor.equalTo(container.centerXAnchor, constant: xConstant),
      centerYAnchor.equalTo(container.centerYAnchor, constant: yConstant)
    )
  }
  
  @discardableResult
  public func pinHorizontalAnchors(inside container: LayoutGuide, leftConstant: CGFloat = 0, rightConstant: CGFloat = 0) -> NSLayoutXAxisConstraints {
    return (
      leftAnchor.equalTo(container.leftAnchor, constant: leftConstant),
      container.rightAnchor.equalTo(rightAnchor, constant: rightConstant)
    )
  }
  
  @discardableResult
  public func pinVerticalAnchors(inside container: LayoutGuide, topConstant: CGFloat = 0, bottomConstant: CGFloat = 0) -> NSLayoutYAxisConstraints {
    return (
      top: topAnchor.equalTo(container.topAnchor, constant: topConstant),
      bottom: container.bottomAnchor.equalTo(bottomAnchor, constant: bottomConstant)
    )
  }
  
  @discardableResult
  public func pinAnchors(inside container: LayoutGuide, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) -> NSLayoutConstraints {
    return .init(
      top: topAnchor.equalTo(container.topAnchor, constant: topConstant),
      left: leftAnchor.equalTo(container.leftAnchor, constant: leftConstant),
      bottom: container.bottomAnchor.equalTo(bottomAnchor, constant: bottomConstant),
      right: container.rightAnchor.equalTo(rightAnchor, constant: rightConstant)
    )
  }
  
  @discardableResult
  public func pinDirectionalAnchors(inside container: LayoutGuide, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) -> NSDirectionalLayoutConstraints {
    return .init(
      top: topAnchor.equalTo(container.topAnchor, constant: topConstant),
      leading: leftAnchor.equalTo(container.leftAnchor, constant: leftConstant),
      bottom: container.bottomAnchor.equalTo(bottomAnchor, constant: bottomConstant),
      trailing: container.rightAnchor.equalTo(rightAnchor, constant: rightConstant)
    )
  }

  public func stack(_ views: [LayoutGuide], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: CGFloat = 0, insets: UIEdgeInsets = .zero) {
    switch axis {
    case .horizontal:
      var constraints: [NSLayoutConstraint] = []

      precondition(distribution == .fillProportionally)
      var lastLayout: (anchor: NSLayoutXAxisAnchor, spacing: CGFloat) = (leftAnchor, insets.left)
      for view in views {
        constraints += view.leftAnchor.constraint(equalTo: lastLayout.anchor, constant: lastLayout.spacing)
        lastLayout = (view.rightAnchor, spacing)
      }
      constraints += rightAnchor.constraint(equalTo: lastLayout.anchor, constant: insets.right)

      precondition(alignment == .fill)
      for view in views {
        constraints += view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        constraints += bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
      }

      NSLayoutConstraint.activate(constraints)

    default:
      fatalError()
    }
  }
}

extension UIView: LayoutGuide { }
extension UILayoutGuide: LayoutGuide { }
#endif
