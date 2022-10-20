//
//  DirectionalXAxisEdges.swift
//
//  Created by Sereivoan Yong on 6/4/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public protocol DirectionalXAxisEdgesProtocol {

  associatedtype DirectionalXAxisItem
  var leading: DirectionalXAxisItem { get set }
  var trailing: DirectionalXAxisItem { get set }
}

extension DirectionalXAxisEdgesProtocol where DirectionalXAxisItem: AdditiveArithmetic {

  public var horizontal: DirectionalXAxisItem {
    leading + trailing
  }
}

public struct DirectionalXAxisEdges<DirectionalXAxisItem>: DirectionalXAxisEdgesProtocol {

  public var leading, trailing: DirectionalXAxisItem

  public init(leading: DirectionalXAxisItem, trailing: DirectionalXAxisItem) {
    self.leading = leading
    self.trailing = trailing
  }

  @inlinable
  public var all: [DirectionalXAxisItem] {
    [leading, trailing]
  }
}

extension DirectionalXAxisEdges: Equatable where DirectionalXAxisItem: Equatable { }
extension DirectionalXAxisEdges: Hashable where DirectionalXAxisItem: Hashable { }
extension DirectionalXAxisEdges: Decodable where DirectionalXAxisItem: Decodable { }
extension DirectionalXAxisEdges: Encodable where DirectionalXAxisItem: Encodable { }

extension DirectionalXAxisEdges: AdditiveArithmetic where DirectionalXAxisItem: AdditiveArithmetic {

  @inlinable
  public static var zero: Self {
    .init(leading: .zero, trailing: .zero)
  }

  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(leading: lhs.leading + rhs.leading, trailing: lhs.trailing + rhs.trailing)
  }

  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    .init(leading: lhs.leading - rhs.leading, trailing: lhs.trailing - rhs.trailing)
  }
}

#endif
