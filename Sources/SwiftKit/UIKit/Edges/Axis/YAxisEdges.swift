//
//  YAxisEdges.swift
//
//  Created by Sereivoan Yong on 6/4/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol YAxisEdgesProtocol {

  associatedtype Item
  
  var top: Item { get set }
  var bottom: Item { get set }
}

extension YAxisEdgesProtocol where Item: AdditiveArithmetic {

  public var vertical: Item {
    return top + bottom
  }

  public var withoutVertical: Self {
    return withVertical(top: .zero, bottom: .zero)
  }

  public func withVertical(top: Item, bottom: Item) -> Self {
    var copy = self
    copy.top = top
    copy.bottom = bottom
    return copy
  }
}

public struct YAxisEdges<Item>: YAxisEdgesProtocol {

  public var top, bottom: Item

  public init(top: Item, bottom: Item) {
    self.top = top
    self.bottom = bottom
  }

  public var all: [Item] {
    return [top, bottom]
  }
}

extension YAxisEdges: Equatable where Item: Equatable { }

extension YAxisEdges: Hashable where Item: Hashable { }

extension YAxisEdges: Decodable where Item: Decodable { }

extension YAxisEdges: Encodable where Item: Encodable { }

extension YAxisEdges: AdditiveArithmetic where Item: AdditiveArithmetic {

  public static var zero: Self {
    return .init(top: .zero, bottom: .zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top + rhs.top, bottom: lhs.bottom + rhs.bottom)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(top: lhs.top - rhs.top, bottom: lhs.bottom - rhs.bottom)
  }
}

#endif
