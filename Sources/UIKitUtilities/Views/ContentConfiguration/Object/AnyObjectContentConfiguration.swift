//
//  AnyObjectContentConfiguration.swift
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit

@available(iOS 14.0, *)
open class AnyObjectContentConfiguration<Object>: UIContentConfiguration {

  open var object: Object

  public init(object: Object) {
    self.object = object
  }

  open func makeContentView() -> UIView & UIContentView {
    fatalError()
  }

  open func updated(for state: UIConfigurationState) -> Self {
    return self
  }
}

@available(iOS 14.0, *)
extension AnyObjectContentConfiguration: Equatable where Object: Equatable {

  public static func == (lhs: AnyObjectContentConfiguration<Object>, rhs: AnyObjectContentConfiguration<Object>) -> Bool {
    return lhs.object == rhs.object
  }
}

@available(iOS 14.0, *)
extension AnyObjectContentConfiguration: Hashable where Object: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(object)
  }
}
