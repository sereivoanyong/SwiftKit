//
//  NSLayoutConstraint.swift
//
//  Created by Sereivoan Yong on 1/27/20.
//

#if canImport(UIKit)
import UIKit

extension NSLayoutConstraint {

  public static func constraints(visualFormats: [String], options: FormatOptions = [], metrics: [String: Any]? = nil, views: [String: LayoutGuide]) -> [NSLayoutConstraint] {
    return visualFormats.flatMap { constraints(withVisualFormat: $0, options: options, metrics: metrics, views: views) }
  }
}

extension Array where Element == NSLayoutConstraint {

  @inlinable
  public func activate() {
    NSLayoutConstraint.activate(self)
  }

  @discardableResult
  public func activated() -> [NSLayoutConstraint] {
    NSLayoutConstraint.activate(self)
    return self
  }

  @inlinable
  public func deactivate() {
    NSLayoutConstraint.deactivate(self)
  }
}
#endif
