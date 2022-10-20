//
//  DirectionalXAxisEdges.swift
//
//  Created by Sereivoan Yong on 6/4/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol DirectionalXAxisEdgesProtocol {

  associatedtype Item
  
  var leading: Item { get set }
  var trailing: Item { get set }
}

extension DirectionalXAxisEdgesProtocol where Item: AdditiveArithmetic {

  public var horizontal: Item {
    return leading + trailing
  }

  public var withoutHorizontal: Self {
    return withHorizontal(leading: .zero, trailing: .zero)
  }

  public func withHorizontal(leading: Item, trailing: Item) -> Self {
    var copy = self
    copy.leading = leading
    copy.trailing = trailing
    return copy
  }
}

public struct DirectionalXAxisEdges<Item>: DirectionalXAxisEdgesProtocol {

  public var leading, trailing: Item

  public init(leading: Item, trailing: Item) {
    self.leading = leading
    self.trailing = trailing
  }

  public var all: [Item] {
    return [leading, trailing]
  }
}

extension DirectionalXAxisEdges: Equatable where Item: Equatable { }

extension DirectionalXAxisEdges: Hashable where Item: Hashable { }

extension DirectionalXAxisEdges: Decodable where Item: Decodable { }

extension DirectionalXAxisEdges: Encodable where Item: Encodable { }

extension DirectionalXAxisEdges: AdditiveArithmetic where Item: AdditiveArithmetic {

  public static var zero: Self {
    return .init(leading: .zero, trailing: .zero)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(leading: lhs.leading + rhs.leading, trailing: lhs.trailing + rhs.trailing)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(leading: lhs.leading - rhs.leading, trailing: lhs.trailing - rhs.trailing)
  }
}

#endif
