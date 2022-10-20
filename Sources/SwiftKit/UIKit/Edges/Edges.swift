//
//  Edges.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

#if os(iOS) && canImport(Foundation)

import Foundation

public struct Edges<XAxisItem, YAxisItem>: EdgesProtocol {

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
}

extension Edges: Equatable where XAxisItem: Equatable, YAxisItem: Equatable { }
extension Edges: Hashable where XAxisItem: Hashable, YAxisItem: Hashable { }
extension Edges: Decodable where XAxisItem: Decodable, YAxisItem: Decodable { }
extension Edges: Encodable where XAxisItem: Encodable, YAxisItem: Encodable { }
extension Edges: AdditiveArithmetic where XAxisItem: AdditiveArithmetic, YAxisItem: AdditiveArithmetic { }

#if canImport(UIKit)

import UIKit

extension UIEdgeInsets: EdgesProtocol {}

extension UIEdgeInsets {

  init(inset: CGFloat) {
    self.init(inset)
  }
}

#endif

#endif
