//
//  XAxisEdges.swift
//
//  Created by Sereivoan Yong on 6/4/21.
//

import Foundation

public protocol XAxisEdgesProtocol<XAxisItem> {

  associatedtype XAxisItem

  var left: XAxisItem { get set }
  var right: XAxisItem { get set }
}

extension XAxisEdgesProtocol where XAxisItem: AdditiveArithmetic {

  public var horizontal: XAxisItem {
    return left + right
  }

  public var withoutHorizontal: Self {
    return withHorizontal(left: .zero, right: .zero)
  }

  public func withHorizontal(left: XAxisItem, right: XAxisItem) -> Self {
    var copy = self
    copy.left = left
    copy.right = right
    return copy
  }
}

public struct XAxisEdges<XAxisItem>: XAxisEdgesProtocol {

  public var left, right: XAxisItem

  public init(left: XAxisItem, right: XAxisItem) {
    self.left = left
    self.right = right
  }

  public init(_ item: XAxisItem) {
    self.init(left: item, right: item)
  }

  public init(_ items: any XAxisEdgesProtocol<XAxisItem>) {
    self.init(left: items.left, right: items.right)
  }
}

extension XAxisEdges: Sequence {

  @inlinable
  __consuming public func makeIterator() -> IndexingIterator<[XAxisItem]> {
    return IndexingIterator<[XAxisItem]>(_elements: [left, right])
  }
}

extension XAxisEdges: Equatable where XAxisItem: Equatable { }

extension XAxisEdges: Hashable where XAxisItem: Hashable { }

extension XAxisEdges: Decodable where XAxisItem: Decodable { }

extension XAxisEdges: Encodable where XAxisItem: Encodable { }

extension XAxisEdges: AdditiveArithmetic where XAxisItem: AdditiveArithmetic {

  public static var zero: Self {
    return .init(.zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(left: lhs.left + rhs.left, right: lhs.right + rhs.right)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(left: lhs.left - rhs.left, right: lhs.right - rhs.right)
  }
}

extension XAxisEdges where XAxisItem: Numeric {

  public static func * (lhs: Self, rhs: XAxisItem) -> Self {
    return .init(left: lhs.left * rhs, right: lhs.right * rhs)
  }
}
