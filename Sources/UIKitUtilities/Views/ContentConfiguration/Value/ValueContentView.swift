//
//  ObjectContentView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
@MainActor public protocol ValueContentView<Value>: ContentView where Configuration == ValueContentConfiguration<Value> {

  associatedtype Value

  @MainActor func configure(_ value: Value)
}

@available(iOS 14.0, *)
extension ValueContentView {

  public var configurationValue: Value! {
    return _configurationIfSet?.value
  }

  @MainActor public func configure(_ configuration: ValueContentConfiguration<Value>) {
    configure(configuration.value)
  }
}
