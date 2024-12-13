//
//  Edges+Insets.swift
//
//  Created by Sereivoan Yong on 5/29/21.
//

#if os(iOS) && canImport(UIKit)

import UIKit

// MARK: Directional Edges

extension NSDirectionalEdgeInsets: DirectionalEdgesProtocol { }

extension NSDirectionalEdgeInsets: @retroactive Hashable { }

public typealias DirectionalEdgeInsets = DirectionalEdges<CGFloat>

extension DirectionalEdgesProtocol where AxisItem == NSLayoutConstraint {

  public var constants: DirectionalEdgeInsets {
    get { return map { $0.constant } }
    set { set(newValue, at: \.constant) }
  }
}

// MARK: Edges

extension UIEdgeInsets: EdgesProtocol { }

extension UIEdgeInsets: @retroactive Hashable { }

public typealias EdgeInsets = Edges<CGFloat>

extension EdgesProtocol where AxisItem == NSLayoutConstraint {

  public var constants: EdgeInsets {
    get { return map { $0.constant } }
    set { set(newValue, at: \.constant) }
  }
}

#endif
