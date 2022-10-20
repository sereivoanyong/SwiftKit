//
//  YAxisEdges.swift
//
//  Created by Sereivoan Yong on 6/4/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol YAxisEdgesProtocol {

  associatedtype YAxisItem
  var top: YAxisItem { get set }
  var bottom: YAxisItem { get set }
}

extension YAxisEdgesProtocol where YAxisItem: AdditiveArithmetic {

  public var vertical: YAxisItem {
    top + bottom
  }
}

public struct YAxisEdges<YAxisItem>: YAxisEdgesProtocol {

  public var top, bottom: YAxisItem

  public init(top: YAxisItem, bottom: YAxisItem) {
    self.top = top
    self.bottom = bottom
  }

  @inlinable
  public var all: [YAxisItem] {
    [top, bottom]
  }
}

extension YAxisEdges: Equatable where YAxisItem: Equatable { }
extension YAxisEdges: Hashable where YAxisItem: Hashable { }
extension YAxisEdges: Decodable where YAxisItem: Decodable { }
extension YAxisEdges: Encodable where YAxisItem: Encodable { }

extension YAxisEdges: AdditiveArithmetic where YAxisItem: AdditiveArithmetic {

  @inlinable
  public static var zero: Self {
    .init(top: .zero, bottom: .zero)
  }

  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(top: lhs.top + rhs.top, bottom: lhs.bottom + rhs.bottom)
  }

  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    .init(top: lhs.top - rhs.top, bottom: lhs.bottom - rhs.bottom)
  }
}

#endif
