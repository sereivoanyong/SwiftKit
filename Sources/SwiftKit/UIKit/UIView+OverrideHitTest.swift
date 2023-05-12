//
//  UIView+OverrideHitTest.swift
//
//  Created by Sereivoan Yong on 12/5/23.
//

#if canImport(UIKit)
import UIKit

extension UIView {

  private static let _override_hit_test_swizzler: Void = {
    class_exchangeInstanceMethodImplementations(UIView.self, #selector(point(inside:with:)), #selector(_override_hit_test_point(inside:with:)))
  }()

  private static var overrideHitTestInsetsKey: Void?

  /// Set to negative to increase and positive to decrease
  public var overrideHitTestInsets: UIEdgeInsets? {
    get { return associatedValue(forKey: &Self.overrideHitTestInsetsKey) }
    set {
      _ = Self._override_hit_test_swizzler
      setAssociatedValue(newValue, forKey: &Self.overrideHitTestInsetsKey)
    }
  }

  @objc private func _override_hit_test_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    if let overrideHitTestInsets {
      return bounds.inset(by: overrideHitTestInsets).contains(point)
    }
    return _override_hit_test_point(inside: point, with: event)
  }
}
#endif
