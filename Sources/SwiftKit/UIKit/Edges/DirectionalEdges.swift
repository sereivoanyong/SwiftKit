//
//  DirectionalEdges.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol DirectionalEdgesProtocol: DirectionalXAxisEdgesProtocol, YAxisEdgesProtocol {

  init(top: Item, leading: Item, bottom: Item, trailing: Item)
}

extension DirectionalEdgesProtocol {

  public init(_ item: Item) {
    self.init(top: item, leading: item, bottom: item, trailing: item)
  }

  /// `let insets = DirectionalEdges<NSLayoutConstraint>(...).map { $0.constant }`
  public func map<T>(_ transform: (Item) -> T) -> DirectionalEdges<T> {
    .init(top: transform(top), leading: transform(leading), bottom: transform(bottom), trailing: transform(trailing))
  }

  public mutating func set<T>(_ edges: DirectionalEdges<T>, at keyPath: WritableKeyPath<Item, T>) {
    top[keyPath: keyPath] = edges.top
    leading[keyPath: keyPath] = edges.leading
    bottom[keyPath: keyPath] = edges.bottom
    trailing[keyPath: keyPath] = edges.trailing
  }

  public mutating func update<T>(_ newEdges: DirectionalEdges<T>, set: (inout Item, T) -> Void) {
    set(&top, newEdges.top)
    set(&leading, newEdges.leading)
    set(&bottom, newEdges.bottom)
    set(&trailing, newEdges.trailing)
  }

  public var all: [Item] {
    return [top, leading, bottom, trailing]
  }
}

extension DirectionalEdgesProtocol where Item: AdditiveArithmetic {

  public static var zero: Self {
    return .init(top: .zero, leading: .zero, bottom: .zero, trailing: .zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top + rhs.top, leading: lhs.leading + rhs.leading, bottom: lhs.bottom + rhs.bottom, trailing: lhs.trailing + rhs.trailing)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top - rhs.top, leading: lhs.leading - rhs.leading, bottom: lhs.bottom - rhs.bottom, trailing: lhs.trailing - rhs.trailing)
  }
}

extension DirectionalEdgesProtocol where Item: Numeric {

  public static func * (lhs: Self, rhs: Item) -> Self {
    return .init(top: lhs.top * rhs, leading: lhs.leading * rhs, bottom: lhs.bottom * rhs, trailing: lhs.trailing * rhs)
  }
}

public struct DirectionalEdges<Item>: DirectionalEdgesProtocol {

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
}

extension DirectionalEdges: Equatable where Item: Equatable { }

extension DirectionalEdges: Hashable where Item: Hashable { }

extension DirectionalEdges: Decodable where Item: Decodable { }

extension DirectionalEdges: Encodable where Item: Encodable { }

extension DirectionalEdges: AdditiveArithmetic where Item: AdditiveArithmetic { }

#if canImport(UIKit)

import UIKit

extension NSDirectionalEdgeInsets: DirectionalEdgesProtocol {}

#endif

#endif
