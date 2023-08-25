//
//  DirectionalEdges.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

import Foundation

public protocol DirectionalEdgesProtocol<AxisItem>: DirectionalXAxisEdgesProtocol, YAxisEdgesProtocol where AxisItem == XAxisItem, AxisItem == YAxisItem {

  associatedtype AxisItem

  init(top: AxisItem, leading: AxisItem, bottom: AxisItem, trailing: AxisItem)
}

extension DirectionalEdgesProtocol {

  public init(_ item: AxisItem) {
    self.init(top: item, leading: item, bottom: item, trailing: item)
  }

  public init(_ items: any DirectionalEdgesProtocol<AxisItem>) {
    self.init(top: items.top, leading: items.leading, bottom: items.bottom, trailing: items.trailing)
  }

  public func map<T>(_ transform: (AxisItem) -> T) -> DirectionalEdges<T> {
    return .init(top: transform(top), leading: transform(leading), bottom: transform(bottom), trailing: transform(trailing))
  }

  public mutating func set<T>(_ edges: any DirectionalEdgesProtocol<T>, at keyPath: WritableKeyPath<AxisItem, T>) {
    top[keyPath: keyPath] = edges.top
    leading[keyPath: keyPath] = edges.leading
    bottom[keyPath: keyPath] = edges.bottom
    trailing[keyPath: keyPath] = edges.trailing
  }

  public mutating func update<T>(with edges: any DirectionalEdgesProtocol<T>, by set: (inout AxisItem, T) -> Void) {
    set(&top, edges.top)
    set(&leading, edges.leading)
    set(&bottom, edges.bottom)
    set(&trailing, edges.trailing)
  }
}

extension DirectionalEdgesProtocol where AxisItem: AdditiveArithmetic {

  public init(top: AxisItem, bottom: AxisItem) {
    self.init(top: top, leading: .zero, bottom: bottom, trailing: .zero)
  }

  public init(leading: AxisItem, trailing: AxisItem) {
    self.init(top: .zero, leading: leading, bottom: .zero, trailing: trailing)
  }

  public static var zero: Self {
    return .init(.zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top + rhs.top, leading: lhs.leading + rhs.leading, bottom: lhs.bottom + rhs.bottom, trailing: lhs.trailing + rhs.trailing)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top - rhs.top, leading: lhs.leading - rhs.leading, bottom: lhs.bottom - rhs.bottom, trailing: lhs.trailing - rhs.trailing)
  }
}

extension DirectionalEdgesProtocol where AxisItem: Numeric {

  public static func * (lhs: Self, rhs: AxisItem) -> Self {
    return .init(top: lhs.top * rhs, leading: lhs.leading * rhs, bottom: lhs.bottom * rhs, trailing: lhs.trailing * rhs)
  }
}

public struct DirectionalEdges<AxisItem>: DirectionalEdgesProtocol {

  public var top: AxisItem
  public var leading: AxisItem
  public var bottom: AxisItem
  public var trailing: AxisItem

  public init(top: AxisItem, leading: AxisItem, bottom: AxisItem, trailing: AxisItem) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
}

extension DirectionalEdges: Sequence {

  @inlinable
  __consuming public func makeIterator() -> IndexingIterator<[AxisItem]> {
    return IndexingIterator<[AxisItem]>(_elements: [top, leading, bottom, trailing])
  }
}

extension DirectionalEdges: Equatable where AxisItem: Equatable { }

extension DirectionalEdges: Hashable where AxisItem: Hashable { }

extension DirectionalEdges: Decodable where AxisItem: Decodable { }

extension DirectionalEdges: Encodable where AxisItem: Encodable { }

extension DirectionalEdges: AdditiveArithmetic where AxisItem: AdditiveArithmetic { }

public struct DirectionalAxisEdges<XAxisItem, YAxisItem>: DirectionalXAxisEdgesProtocol, YAxisEdgesProtocol {

  public var top: YAxisItem
  public var leading: XAxisItem
  public var bottom: YAxisItem
  public var trailing: XAxisItem

  public init(top: YAxisItem, leading: XAxisItem, bottom: YAxisItem, trailing: XAxisItem) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }

  public init(xAxis: any DirectionalXAxisEdgesProtocol<XAxisItem>, yAxis: any YAxisEdgesProtocol<YAxisItem>) {
    self.init(top: yAxis.top, leading: xAxis.leading, bottom: yAxis.bottom, trailing: xAxis.trailing)
  }
}

extension DirectionalAxisEdges: Equatable where XAxisItem: Equatable, YAxisItem: Equatable { }

extension DirectionalAxisEdges: Hashable where XAxisItem: Hashable, YAxisItem: Hashable { }

extension DirectionalAxisEdges: Decodable where XAxisItem: Decodable, YAxisItem: Decodable { }

extension DirectionalAxisEdges: Encodable where XAxisItem: Encodable, YAxisItem: Encodable { }
