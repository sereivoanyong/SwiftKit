//
//  Edges.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

import Foundation

public protocol EdgesProtocol<AxisItem>: XAxisEdgesProtocol, YAxisEdgesProtocol where AxisItem == XAxisItem, AxisItem == YAxisItem {

  associatedtype AxisItem

  init(top: AxisItem, left: AxisItem, bottom: AxisItem, right: AxisItem)
}

extension EdgesProtocol {

  public init(_ item: AxisItem) {
    self.init(top: item, left: item, bottom: item, right: item)
  }

  public init(_ items: any EdgesProtocol<AxisItem>) {
    self.init(top: items.top, left: items.left, bottom: items.bottom, right: items.right)
  }

  public func map<T>(_ transform: (AxisItem) -> T) -> Edges<T> {
    return .init(top: transform(top), left: transform(left), bottom: transform(bottom), right: transform(right))
  }

  public mutating func set<T>(_ edges: any EdgesProtocol<T>, at keyPath: WritableKeyPath<AxisItem, T>) {
    top[keyPath: keyPath] = edges.top
    left[keyPath: keyPath] = edges.left
    bottom[keyPath: keyPath] = edges.bottom
    right[keyPath: keyPath] = edges.right
  }

  public mutating func update<T>(with edges: any EdgesProtocol<T>, by set: (inout AxisItem, T) -> Void) {
    set(&top, edges.top)
    set(&left, edges.left)
    set(&bottom, edges.bottom)
    set(&right, edges.right)
  }
}

extension EdgesProtocol where AxisItem: AdditiveArithmetic {

  public init(top: AxisItem, bottom: AxisItem) {
    self.init(top: top, left: .zero, bottom: bottom, right: .zero)
  }

  public init(left: AxisItem, right: AxisItem) {
    self.init(top: .zero, left: left, bottom: .zero, right: right)
  }

  public static var zero: Self {
    return .init(.zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
  }
}

extension EdgesProtocol where AxisItem: Numeric {

  public static func * (lhs: Self, rhs: AxisItem) -> Self {
    return .init(top: lhs.top * rhs, left: lhs.left * rhs, bottom: lhs.bottom * rhs, right: lhs.right * rhs)
  }
}

public struct Edges<AxisItem>: EdgesProtocol {

  public var top: AxisItem
  public var left: AxisItem
  public var bottom: AxisItem
  public var right: AxisItem

  public init(top: AxisItem, left: AxisItem, bottom: AxisItem, right: AxisItem) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }
}

extension Edges: Sequence {

  @inlinable
  __consuming public func makeIterator() -> IndexingIterator<[AxisItem]> {
    return IndexingIterator<[AxisItem]>(_elements: [top, left, bottom, right])
  }
}

extension Edges: Equatable where AxisItem: Equatable { }

extension Edges: Hashable where AxisItem: Hashable { }

extension Edges: Decodable where AxisItem: Decodable { }

extension Edges: Encodable where AxisItem: Encodable { }

extension Edges: AdditiveArithmetic where AxisItem: AdditiveArithmetic { }

public struct AxisEdges<XAxisItem, YAxisItem>: XAxisEdgesProtocol, YAxisEdgesProtocol {

  public var top: YAxisItem
  public var left: XAxisItem
  public var bottom: YAxisItem
  public var right: XAxisItem

  public init(top: YAxisItem, left: XAxisItem, bottom: YAxisItem, right: XAxisItem) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  public init(xAxis: any XAxisEdgesProtocol<XAxisItem>, yAxis: any YAxisEdgesProtocol<YAxisItem>) {
    self.init(top: yAxis.top, left: xAxis.left, bottom: yAxis.bottom, right: xAxis.right)
  }
}

extension AxisEdges: Equatable where XAxisItem: Equatable, YAxisItem: Equatable { }

extension AxisEdges: Hashable where XAxisItem: Hashable, YAxisItem: Hashable { }

extension AxisEdges: Decodable where XAxisItem: Decodable, YAxisItem: Decodable { }

extension AxisEdges: Encodable where XAxisItem: Encodable, YAxisItem: Encodable { }
