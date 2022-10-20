//
//  File.swift
//  
//
//  Created by Sereivoan Yong on 10/20/22.
//

import Foundation

public protocol EdgesProtocol: XAxisEdgesProtocol, YAxisEdgesProtocol {

  init(top: YAxisItem, left: XAxisItem, bottom: YAxisItem, right: XAxisItem)
}

extension EdgesProtocol {

  public init<XAxisEdges: XAxisEdgesProtocol, YAxisEdges: YAxisEdgesProtocol>(
    horizontal: XAxisEdges, vertical: YAxisEdges
  ) where XAxisEdges.XAxisItem == XAxisItem, YAxisEdges.YAxisItem == YAxisItem {
    self.init(top: vertical.top, left: horizontal.left, bottom: vertical.bottom, right: horizontal.right)
  }

  /// `let insets = Edges<NSLayoutConstraint>(...).map { $0.constant }`
  public func map<Item, T>(_ transform: (Item) -> T) -> Edges<T, T> where Item == XAxisItem, Item == YAxisItem {
    .init(top: transform(top), left: transform(left), bottom: transform(bottom), right: transform(right))
  }

  public mutating func set<Item, T>(_ edges: Edges<T, T>, at keyPath: WritableKeyPath<Item, T>) where Item == XAxisItem, Item == YAxisItem {
    top[keyPath: keyPath] = edges.top
    left[keyPath: keyPath] = edges.left
    bottom[keyPath: keyPath] = edges.bottom
    right[keyPath: keyPath] = edges.right
  }

  public mutating func update<Item, T>(_ newEdges: Edges<T, T>, set: (inout Item, T) -> Void) where Item == XAxisItem, Item == YAxisItem {
    set(&top, newEdges.top)
    set(&left, newEdges.left)
    set(&bottom, newEdges.bottom)
    set(&right, newEdges.right)
  }
}

extension EdgesProtocol where XAxisItem == YAxisItem {

  public init(_ item: XAxisItem) {
    self.init(top: item, left: item, bottom: item, right: item)
  }

  @inlinable
  public var all: [XAxisItem] {
    return [top, left, bottom, right]
  }
}

extension EdgesProtocol where XAxisItem: AdditiveArithmetic {

  @inlinable
  public var withoutHorizontal: Self {
    return withHorizontal(left: .zero, right: .zero)
  }

  @inlinable
  public func withHorizontal(left: XAxisItem, right: XAxisItem) -> Self {
    return Self(top: top, left: left, bottom: bottom, right: right)
  }
}

extension EdgesProtocol where YAxisItem: AdditiveArithmetic {

  @inlinable
  public var withoutVertical: Self {
    return withVertical(top: .zero, bottom: .zero)
  }

  @inlinable
  public func withVertical(top: YAxisItem, bottom: YAxisItem) -> Self {
    return Self(top: top, left: left, bottom: bottom, right: right)
  }
}

extension EdgesProtocol where XAxisItem: AdditiveArithmetic, YAxisItem: AdditiveArithmetic {

  @inlinable
  public static var zero: Self {
    return Self(top: .zero, left: .zero, bottom: .zero, right: .zero)
  }

  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    return Self(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
  }

  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    return Self(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
  }
}

extension EdgesProtocol where XAxisItem: Numeric, XAxisItem
