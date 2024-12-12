//
//  ObjectViewModel.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/23/25.
//

import Foundation

@MainActor public protocol ObjectViewModelProtocol<Object>: AnyObject {

  associatedtype Object

  var object: Object { get set }
}

@MainActor open class ObjectViewModel<Object: Hashable>: NSObject, ObjectViewModelProtocol {

  open var object: Object

  @MainActor public init(object: Object) {
    self.object = object
  }

  open override func isEqual(_ viewModel: Any?) -> Bool {
    guard let viewModel = viewModel as? ObjectViewModel<Object> else {
      return false
    }
    if viewModel === self {
      return true
    }
    return viewModel.object == object
  }

  open override var hash: Int {
    var hasher = Hasher()
    hasher.combine(object)
    return hasher.finalize()
  }
}
