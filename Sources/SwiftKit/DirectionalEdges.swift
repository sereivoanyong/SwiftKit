//
//  DirectionalEdges.swift
//
//  Created by Sereivoan Yong on 10/21/20.
//

public struct DirectionalEdges<Item> {
  
  public var top: Item
  public var leading: Item
  public var bottom: Item
  public var trailing: Item
  
  public init(top: Item, leading: Item, bottom: Item, trailing: Item) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
  
  public var array: [Item] {
    return [top, leading, bottom, trailing]
  }
  
  public func map<T>(_ transform: (Item) -> T) -> DirectionalEdges<T> {
    return DirectionalEdges<T>(top: transform(top), leading: transform(leading), bottom: transform(bottom), trailing: transform(trailing))
  }
  
  @inlinable public mutating func update<T>(_ edges: DirectionalEdges<T>, update: (inout Item, T) -> Void) {
    update(&top, edges.top)
    update(&leading, edges.leading)
    update(&bottom, edges.bottom)
    update(&trailing, edges.trailing)
  }
  
  @inlinable public mutating func update<T>(_ newEdges: DirectionalEdges<T>, on keyPath: ReferenceWritableKeyPath<Item, T>) {
    top[keyPath: keyPath] = newEdges.top
    leading[keyPath: keyPath] = newEdges.leading
    bottom[keyPath: keyPath] = newEdges.bottom
    trailing[keyPath: keyPath] = newEdges.trailing
  }
}

extension DirectionalEdges: Equatable where Item: Equatable { }

extension DirectionalEdges: Codable where Item: Codable { }

#if canImport(UIKit)
import UIKit

@available(iOS 11.0, *)
extension DirectionalEdges where Item == CGFloat {
  
  @inlinable public var ns: NSDirectionalEdgeInsets {
    return NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
  }
  
  @inlinable public init(ns: NSDirectionalEdgeInsets) {
    self = .init(top: ns.top, leading: ns.leading, bottom: ns.bottom, trailing: ns.trailing)
  }
}

extension DirectionalEdges where Item == NSLayoutConstraint {
  
  @inlinable public var constants: DirectionalEdges<CGFloat> {
    get { return .init(top: top.constant, leading: leading.constant, bottom: bottom.constant, trailing: trailing.constant) }
    set { update(newValue, on: \.constant) }
  }
}
#endif
