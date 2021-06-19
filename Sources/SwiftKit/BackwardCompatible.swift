//
//  BackwardCompatible.swift
//
//  Created by Sereivoan Yong on 6/19/21.
//

import Foundation

public protocol BackwardCompatible {

}

extension BackwardCompatible {

  public typealias BC = BackwardCompatibility<Self>

  public var bc: BackwardCompatibility<Self> {
    .init(base: self)
  }
}

public struct BackwardCompatibility<Base> {

  public let base: Base
}
