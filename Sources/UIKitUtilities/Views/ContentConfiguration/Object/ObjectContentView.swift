//
//  ObjectContentView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
@MainActor public protocol ObjectContentView<Object>: UIView, UIContentView {

  associatedtype Object

  @MainActor var objectConfiguration: ObjectContentConfiguration<Object> { get set }

  @MainActor func configure(_ object: Object)
}

private var __configurationKey: Void?

@available(iOS 14.0, *)
extension ObjectContentView {

  @MainActor public var __configuration: UIContentConfiguration? {
    get { return associatedValue(forKey: &__configurationKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &__configurationKey, with: self) }
  }

  @MainActor public var configuration: UIContentConfiguration {
    get { return __configuration! }
    set {
      __configuration = newValue
      if let newValue = newValue as? ObjectContentConfiguration<Object> {
        configure(newValue.object)
      }
    }
  }

  @inlinable
  @MainActor public var objectConfiguration: ObjectContentConfiguration<Object> {
    get { return __configuration as! ObjectContentConfiguration<Object> }
    set {
      __configuration = newValue
      configure(newValue.object)
    }
  }

  @inlinable
  public var object: Object {
    return objectConfiguration.object
  }

  @MainActor public func supports(_ configuration: UIContentConfiguration) -> Bool {
    return configuration is ObjectContentConfiguration<Object>
  }
}
