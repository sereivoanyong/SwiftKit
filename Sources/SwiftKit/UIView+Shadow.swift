//
//  UIView+Shadow.swift
//
//  Created by Sereivoan Yong on 12/29/19.
//

#if canImport(UIKit)
import UIKit

extension UIView {
  
  fileprivate static var defaultShadowColor: UIColor {
    // @see: https://github.com/noahsark769/ColorCompatibility/blob/master/ColorCompatibility.swift
    if #available(iOS 13, *) {
      return .separator
    } else {
      return .integer(red: 60, green: 60, blue: 67, alpha: 29)
    }
  }
  
  private static var shadowViewsKey: Void?
  
  final public fileprivate(set) var shadowViews: [CGRectEdge: UIView] {
    get { return associatedValue(forKey: &Self.shadowViewsKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &Self.shadowViewsKey) }
  }
  
  @discardableResult
  final public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, thickness: CGFloat = .pixel) -> UIView {
    assert(shadowViews[edge] == nil, "Existing shadow view at \(edge) edge found.")
    let frame: CGRect
    let autoresizingMask: UIView.AutoresizingMask
    switch edge {
    case .minXEdge:
      frame = CGRect(x: clipsToBounds ? 0 : -thickness, y: 0, width: thickness, height: bounds.size.height)
      autoresizingMask = .flexibleHeight
      
    case .maxXEdge:
      frame = CGRect(x: clipsToBounds ? (bounds.size.width - thickness) : bounds.size.width, y: 0, width: thickness, height: bounds.size.height)
      autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
      
    case .minYEdge:
      frame = CGRect(x: 0, y: clipsToBounds ? 0 : -thickness, width: bounds.size.width, height: thickness)
      autoresizingMask = .flexibleWidth
      
    case .maxYEdge:
      frame = CGRect(x: 0, y: clipsToBounds ? (bounds.size.height - thickness) : bounds.size.height, width: bounds.size.width, height: thickness)
      autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }
    let shadowView = UIView(frame: frame)
    shadowView.autoresizingMask = autoresizingMask
    shadowView.backgroundColor = color ?? Self.defaultShadowColor
    addSubview(shadowView)
    shadowViews[edge] = shadowView
    return shadowView
  }
  
  @discardableResult
  final public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, thickness: CGFloat = .pixel, target: LayoutGuide? = nil, layoutGuide: LayoutGuide, inset: UIEdgeInsets = .zero) -> UIView {
    assert(shadowViews[edge] == nil, "Existing shadow view at \(edge) edge found.")
    let shadowView = UIView()
    shadowView.backgroundColor = color ?? Self.defaultShadowColor
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(shadowView)
    
    let target = target ?? self
    let constraints: [NSLayoutConstraint]
    switch edge {
    case .minXEdge:
      constraints = [
        shadowView.widthAnchor.constraint(equalToConstant: thickness),
        shadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: inset.top),
        layoutGuide.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: inset.bottom),
        target.leftAnchor.constraint(equalTo: shadowView.rightAnchor, constant: clipsToBounds ? -thickness : thickness),
      ]
      
    case .maxXEdge:
      constraints = [
        shadowView.widthAnchor.constraint(equalToConstant: thickness),
        shadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: inset.top),
        shadowView.leftAnchor.constraint(equalTo: target.rightAnchor, constant: clipsToBounds ? -thickness : thickness),
        layoutGuide.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: inset.bottom),
      ]
      
    case .minYEdge:
      constraints = [
        shadowView.heightAnchor.constraint(equalToConstant: thickness),
        shadowView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: inset.left),
        target.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: clipsToBounds ? -thickness : thickness),
        layoutGuide.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: inset.right),
      ]
      
    case .maxYEdge:
      constraints = [
        shadowView.heightAnchor.constraint(equalToConstant: thickness),
        shadowView.topAnchor.constraint(equalTo: target.bottomAnchor, constant: clipsToBounds ? -thickness : thickness),
        shadowView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: inset.left),
        layoutGuide.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: inset.right),
      ]
    }
    NSLayoutConstraint.activate(constraints)
    shadowViews[edge] = shadowView
    return shadowView
  }
  
  @discardableResult
  final public func removeShadowView(at edge: CGRectEdge) -> UIView? {
    if let shadowView = shadowViews.removeValue(forKey: edge) {
      shadowView.removeFromSuperview()
      return shadowView
    }
    return nil
  }
}

extension NSObjectProtocol where Self: UIView {
  
  @discardableResult
  public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, constraintsProvider: (Self, UIView) -> [NSLayoutConstraint]) -> UIView {
    assert(shadowViews[edge] == nil, "Existing shadow view at \(edge) edge found.")
    let shadowView = UIView()
    shadowView.backgroundColor = color ?? Self.defaultShadowColor
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(shadowView)
    NSLayoutConstraint.activate(constraintsProvider(self, shadowView))
    shadowViews[edge] = shadowView
    return shadowView
  }
}
#endif
