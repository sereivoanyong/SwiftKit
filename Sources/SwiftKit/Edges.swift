//
//  Edges.swift
//
//  Created by Sereivoan Yong on 10/21/20.
//

public struct Edges<Item> {
  
  public var top: Item
  public var left: Item
  public var bottom: Item
  public var right: Item
  
  public init(top: Item, left: Item, bottom: Item, right: Item) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }
  
  public var array: [Item] {
    return [top, left, bottom, right]
  }
  
  public func map<T>(_ transform: (Item) -> T) -> Edges<T> {
    return Edges<T>(top: transform(top), left: transform(left), bottom: transform(bottom), right: transform(right))
  }
  
  @inlinable public mutating func update<T>(_ newEdges: Edges<T>, update: (inout Item, T) -> Void) {
    update(&top, newEdges.top)
    update(&left, newEdges.left)
    update(&bottom, newEdges.bottom)
    update(&right, newEdges.right)
  }
  
  @inlinable public mutating func update<T>(_ newEdges: Edges<T>, on keyPath: ReferenceWritableKeyPath<Item, T>) {
    top[keyPath: keyPath] = newEdges.top
    left[keyPath: keyPath] = newEdges.left
    bottom[keyPath: keyPath] = newEdges.bottom
    right[keyPath: keyPath] = newEdges.right
  }
}

extension Edges: Equatable where Item: Equatable { }

extension Edges: Codable where Item: Codable { }

#if canImport(UIKit)
import UIKit

extension Edges where Item == CGFloat {
  
  @inlinable public var ui: UIEdgeInsets {
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
  
  @inlinable public init(ui: UIEdgeInsets) {
    self = .init(top: ui.top, left: ui.left, bottom: ui.bottom, right: ui.right)
  }
}

extension Edges where Item == NSLayoutConstraint {
  
  @inlinable public var constants: Edges<CGFloat> {
    get { return .init(top: top.constant, left: left.constant, bottom: bottom.constant, right: right.constant) }
    set { update(newValue, on: \.constant) }
  }
}
#endif
