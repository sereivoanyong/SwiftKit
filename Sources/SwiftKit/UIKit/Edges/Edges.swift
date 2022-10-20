//
//  Edges.swift
//
//  Created by Sereivoan Yong on 10/20/22.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol EdgesProtocol: XAxisEdgesProtocol, YAxisEdgesProtocol {

  init(top: Item, left: Item, bottom: Item, right: Item)
}

extension EdgesProtocol {

  public init(_ item: Item) {
    self.init(top: item, left: item, bottom: item, right: item)
  }

  /// `let insets = Edges<NSLayoutConstraint>(...).map { $0.constant }`
  public func map<T>(_ transform: (Item) -> T) -> Edges<T> {
    return .init(top: transform(top), left: transform(left), bottom: transform(bottom), right: transform(right))
  }

  public mutating func set<T>(_ edges: Edges<T>, at keyPath: WritableKeyPath<Item, T>) {
    top[keyPath: keyPath] = edges.top
    left[keyPath: keyPath] = edges.left
    bottom[keyPath: keyPath] = edges.bottom
    right[keyPath: keyPath] = edges.right
  }

  public mutating func update<T>(_ newEdges: Edges<T>, set: (inout Item, T) -> Void) {
    set(&top, newEdges.top)
    set(&left, newEdges.left)
    set(&bottom, newEdges.bottom)
    set(&right, newEdges.right)
  }

  public var all: [Item] {
    return [top, left, bottom, right]
  }
}

extension EdgesProtocol where Item: AdditiveArithmetic {

  public static var zero: Self {
    return .init(top: .zero, left: .zero, bottom: .zero, right: .zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
  }
}

extension EdgesProtocol where Item: Numeric {

  public static func * (lhs: Self, rhs: Item) -> Self {
    return .init(top: lhs.top * rhs, left: lhs.left * rhs, bottom: lhs.bottom * rhs, right: lhs.right * rhs)
  }
}

public struct Edges<Item>: EdgesProtocol {

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
}

extension Edges: Equatable where Item: Equatable { }

extension Edges: Hashable where Item: Hashable { }

extension Edges: Decodable where Item: Decodable { }

extension Edges: Encodable where Item: Encodable { }

extension Edges: AdditiveArithmetic where Item: AdditiveArithmetic { }

#if canImport(UIKit)

import UIKit

extension UIEdgeInsets: EdgesProtocol {}

#endif

#endif
