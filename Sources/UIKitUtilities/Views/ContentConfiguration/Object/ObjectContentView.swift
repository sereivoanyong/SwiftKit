//
//  ObjectContentView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
@MainActor public protocol ObjectContentView<Object>: ContentView where Configuration == ObjectContentConfiguration<Object> {

  associatedtype Object: AnyObject

  @MainActor func configure(_ object: Object)
}

@available(iOS 14.0, *)
extension ObjectContentView {

  public var configurationObject: Object! {
    return _configurationIfSet?.object
  }

  @MainActor public func configure(_ configuration: ObjectContentConfiguration<Object>) {
    configure(configuration.object)
  }
}
