//
//  ObjectViewModel.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/23/25.
//

public protocol ObjectViewModelProtocol<Object>: AnyObject {

  associatedtype Object

  var object: Object { get set }
}

open class ObjectViewModel<Object>: ObjectViewModelProtocol {

  open var object: Object

  public init(object: Object) {
    self.object = object
  }
}

extension ObjectViewModel: Equatable where Object: Equatable {

  public static func == (lhs: ObjectViewModel<Object>, rhs: ObjectViewModel<Object>) -> Bool {
    return lhs.object == rhs.object
  }
}

extension ObjectViewModel: Hashable where Object: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(object)
  }
}
