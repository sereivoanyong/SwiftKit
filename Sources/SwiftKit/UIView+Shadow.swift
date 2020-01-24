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
  
  /// Return all shadow views added by `addShadowView(at:color:height:)`
  final public fileprivate(set) var shadowViews: [CGRectEdge: UIView] {
    get { return associatedValue(forKey: &Self.shadowViewsKey, default: [:]) }
    set { setAssociatedValue(newValue, forKey: &Self.shadowViewsKey) }
  }
  
  /// Add shadow view
  /// - Parameters:
  ///   - edge: edge to add shadow
  ///   - color: shadow color. `UIColor.separator` is used when the value is nil
  ///   - height: shadow height
  ///   - layoutGuide: set to nil to use autoresizing mask
  @discardableResult
  final public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, thickness: CGFloat = .pixel, layoutGuide: LayoutGuide? = nil) -> UIView {
    if let shadowView = shadowViews[edge] {
      assertionFailure("Existing shadow view at \(edge) edge found.")
      return shadowView
    }
    let shadowView = UIView()
    shadowView.backgroundColor = color ?? Self.defaultShadowColor
    if let layoutGuide = layoutGuide {
      shadowView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(shadowView)
      
      var constraints: [NSLayoutConstraint]
      switch edge {
      case .minXEdge:
        constraints = [
          shadowView.widthAnchor.constraint(equalToConstant: thickness),
          shadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
          layoutGuide.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ]
        if clipsToBounds {
          constraints.append(shadowView.leftAnchor.constraint(equalTo: leftAnchor))
        } else {
          constraints.append(leftAnchor.constraint(equalTo: shadowView.rightAnchor))
        }
        
      case .maxXEdge:
        constraints = [
          shadowView.widthAnchor.constraint(equalToConstant: thickness),
          shadowView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
          layoutGuide.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ]
        if clipsToBounds {
          constraints.append(shadowView.leftAnchor.constraint(equalTo: rightAnchor))
        } else {
          constraints.append(rightAnchor.constraint(equalTo: shadowView.rightAnchor))
        }
        
      case .minYEdge:
        constraints = [
          shadowView.heightAnchor.constraint(equalToConstant: thickness),
          shadowView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
          layoutGuide.rightAnchor.constraint(equalTo: shadowView.rightAnchor)
        ]
        if clipsToBounds {
          constraints.append(shadowView.topAnchor.constraint(equalTo: topAnchor))
        } else {
          constraints.append(topAnchor.constraint(equalTo: shadowView.bottomAnchor))
        }
        
      case .maxYEdge:
        constraints = [
          shadowView.heightAnchor.constraint(equalToConstant: thickness),
          shadowView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
          layoutGuide.rightAnchor.constraint(equalTo: shadowView.rightAnchor)
        ]
        if clipsToBounds {
          constraints.append(bottomAnchor.constraint(equalTo: shadowView.bottomAnchor))
        } else {
          constraints.append(shadowView.topAnchor.constraint(equalTo: bottomAnchor))
        }
      }
      NSLayoutConstraint.activate(constraints)
    } else {
      switch edge {
      case .minXEdge:
        shadowView.frame = CGRect(x: clipsToBounds ? 0 : -thickness, y: 0, width: thickness, height: bounds.size.height)
        shadowView.autoresizingMask = .flexibleHeight
        
      case .maxXEdge:
        shadowView.frame = CGRect(x: clipsToBounds ? (bounds.size.width - thickness) : bounds.size.width, y: 0, width: thickness, height: bounds.size.height)
        shadowView.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        
      case .minYEdge:
        shadowView.frame = CGRect(x: 0, y: clipsToBounds ? 0 : -thickness, width: bounds.size.width, height: thickness)
        shadowView.autoresizingMask = .flexibleWidth
        
      case .maxYEdge:
        shadowView.frame = CGRect(x: 0, y: clipsToBounds ? (bounds.size.height - thickness) : bounds.size.height, width: bounds.size.width, height: thickness)
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
      }
      addSubview(shadowView)
    }
    shadowViews[edge] = shadowView
    return shadowView
  }
  
  @discardableResult
  final public func removeShadowView(at edge: CGRectEdge) -> UIView? {
    guard let shadowView = shadowViews.removeValue(forKey: edge) else {
      return nil
    }
    shadowView.removeFromSuperview()
    return shadowView
  }
}

extension NSObjectProtocol where Self: UIView {
  
  @discardableResult
  public func addShadowView(at edge: CGRectEdge, color: UIColor? = nil, constraintsProvider: (Self, UIView) -> [NSLayoutConstraint]) -> UIView {
    if let shadowView = shadowViews[edge] {
      assertionFailure("Existing shadow view at \(edge) edge found.")
      return shadowView
    }
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
