//
//  XAxisEdges.swift
//
//  Created by Sereivoan Yong on 6/4/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol XAxisEdgesProtocol {

  associatedtype Item
  
  var left: Item { get set }
  var right: Item { get set }
}

extension XAxisEdgesProtocol where Item: AdditiveArithmetic {

  public var horizontal: Item {
    return left + right
  }

  public var withoutHorizontal: Self {
    return withHorizontal(left: .zero, right: .zero)
  }

  public func withHorizontal(left: Item, right: Item) -> Self {
    var copy = self
    copy.left = left
    copy.right = right
    return copy
  }
}

public struct XAxisEdges<Item>: XAxisEdgesProtocol {

  public var left, right: Item

  public init(left: Item, right: Item) {
    self.left = left
    self.right = right
  }

  public var all: [Item] {
    return [left, right]
  }
}

extension XAxisEdges: Equatable where Item: Equatable { }

extension XAxisEdges: Hashable where Item: Hashable { }

extension XAxisEdges: Decodable where Item: Decodable { }

extension XAxisEdges: Encodable where Item: Encodable { }

extension XAxisEdges: AdditiveArithmetic where Item: AdditiveArithmetic {

  public static var zero: Self {
    return .init(left: .zero, right: .zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(left: lhs.left + rhs.left, right: lhs.right + rhs.right)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(left: lhs.left - rhs.left, right: lhs.right - rhs.right)
  }
}

#endif
