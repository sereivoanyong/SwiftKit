//
//  XAxisEdges.swift
//
//  Created by Sereivoan Yong on 6/4/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol XAxisEdgesProtocol {

  associatedtype XAxisItem
  var left: XAxisItem { get set }
  var right: XAxisItem { get set }
}

extension XAxisEdgesProtocol where XAxisItem: AdditiveArithmetic {

  public var horizontal: XAxisItem {
    return left + right
  }
}

public struct XAxisEdges<XAxisItem>: XAxisEdgesProtocol {

  public var left, right: XAxisItem

  public init(left: XAxisItem, right: XAxisItem) {
    self.left = left
    self.right = right
  }

  @inlinable
  public var all: [XAxisItem] {
    [left, right]
  }
}

extension XAxisEdges: Equatable where XAxisItem: Equatable { }
extension XAxisEdges: Hashable where XAxisItem: Hashable { }
extension XAxisEdges: Decodable where XAxisItem: Decodable { }
extension XAxisEdges: Encodable where XAxisItem: Encodable { }

extension XAxisEdges: AdditiveArithmetic where XAxisItem: AdditiveArithmetic {

  @inlinable
  public static var zero: Self {
    .init(left: .zero, right: .zero)
  }

  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(left: lhs.left + rhs.left, right: lhs.right + rhs.right)
  }

  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    .init(left: lhs.left - rhs.left, right: lhs.right - rhs.right)
  }
}

#endif
