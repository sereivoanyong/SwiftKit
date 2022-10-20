//
//  DirectionalEdges.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol DirectionalEdgesProtocol: DirectionalXAxisEdgesProtocol, YAxisEdgesProtocol {

  init(top: YAxisItem, leading: DirectionalXAxisItem, bottom: YAxisItem, trailing: DirectionalXAxisItem)
}

extension DirectionalEdgesProtocol {

  init<DirectionalXAxisEdges: DirectionalXAxisEdgesProtocol, YAxisEdges: YAxisEdgesProtocol>(
    horizontal: DirectionalXAxisEdges, vertical: YAxisEdges
  ) where DirectionalXAxisEdges.DirectionalXAxisItem == DirectionalXAxisItem, YAxisEdges.YAxisItem == YAxisItem {
    self.init(top: vertical.top, leading: horizontal.leading, bottom: vertical.bottom, trailing: horizontal.trailing)
  }

  /// `let insets = DirectionalEdges<NSLayoutConstraint>(...).map { $0.constant }`
  public func map<Item, T>(_ transform: (Item) -> T) -> DirectionalEdges<T, T> where Item == DirectionalXAxisItem, Item == YAxisItem {
    .init(top: transform(top), leading: transform(leading), bottom: transform(bottom), trailing: transform(trailing))
  }

  public mutating func set<Item, T>(_ edges: DirectionalEdges<T, T>, at keyPath: WritableKeyPath<Item, T>) where Item == DirectionalXAxisItem, Item == YAxisItem {
    top[keyPath: keyPath] = edges.top
    leading[keyPath: keyPath] = edges.leading
    bottom[keyPath: keyPath] = edges.bottom
    trailing[keyPath: keyPath] = edges.trailing
  }

  public mutating func update<Item, T>(_ newEdges: DirectionalEdges<T, T>, set: (inout Item, T) -> Void) where Item == DirectionalXAxisItem, Item == YAxisItem {
    set(&top, newEdges.top)
    set(&leading, newEdges.leading)
    set(&bottom, newEdges.bottom)
    set(&trailing, newEdges.trailing)
  }
}

extension DirectionalEdgesProtocol where DirectionalXAxisItem: AdditiveArithmetic, YAxisItem: AdditiveArithmetic {

  @inlinable
  public static var zero: Self {
    .init(top: .zero, leading: .zero, bottom: .zero, trailing: .zero)
  }

  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(top: lhs.top + rhs.top, leading: lhs.leading + rhs.leading, bottom: lhs.bottom + rhs.bottom, trailing: lhs.trailing + rhs.trailing)
  }

  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    .init(top: lhs.top - rhs.top, leading: lhs.leading - rhs.leading, bottom: lhs.bottom - rhs.bottom, trailing: lhs.trailing - rhs.trailing)
  }
}

public struct DirectionalEdges<DirectionalXAxisItem, YAxisItem>: DirectionalEdgesProtocol {

  public var top: YAxisItem
  public var leading: DirectionalXAxisItem
  public var bottom: YAxisItem
  public var trailing: DirectionalXAxisItem

  public init(top: YAxisItem, leading: DirectionalXAxisItem, bottom: YAxisItem, trailing: DirectionalXAxisItem) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
}

extension DirectionalEdges where DirectionalXAxisItem == YAxisItem {

  @inlinable
  public var all: [DirectionalXAxisItem] {
    [top, leading, bottom, trailing]
  }
}

extension DirectionalEdges: Equatable where DirectionalXAxisItem: Equatable, YAxisItem: Equatable { }
extension DirectionalEdges: Hashable where DirectionalXAxisItem: Hashable, YAxisItem: Hashable { }
extension DirectionalEdges: Decodable where DirectionalXAxisItem: Decodable, YAxisItem: Decodable { }
extension DirectionalEdges: Encodable where DirectionalXAxisItem: Encodable, YAxisItem: Encodable { }
extension DirectionalEdges: AdditiveArithmetic where DirectionalXAxisItem: AdditiveArithmetic, YAxisItem: AdditiveArithmetic { }

#endif
