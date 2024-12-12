//
//  ValueContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
public struct ValueContentConfiguration<Value>: AnyContentConfiguration {

  public let contentViewClass: (UIView & UIContentView).Type
  
  public var value: Value

  @MainActor public var handler: Handler

  @MainActor public init<ContentView: ValueContentView<Value>>(
    _ contentViewClass: ContentView.Type,
    _ value: Value,
    handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }
  ) {
    self.value = value
    self.contentViewClass = contentViewClass
    self.handler = { contentView, configuration in
      handler(contentView as! ContentView, configuration)
    }
  }
}

@available(iOS 14.0, *)
extension ValueContentConfiguration: Equatable where Value: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.value == rhs.value && lhs.contentViewClass == rhs.contentViewClass
  }
}

@available(iOS 14.0, *)
extension ValueContentConfiguration: Hashable where Value: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(value)
    hasher.combine(ObjectIdentifier(contentViewClass))
  }
}

@available(iOS 14.0, *)
extension UIContentConfiguration {

  @inlinable
  @MainActor public static func value<Value, ContentView: ValueContentView<Value>>(
    _ contentViewClass: ContentView.Type,
    _ value: Value,
    handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }
  ) -> Self where Self == ValueContentConfiguration<Value> {
    return .init(contentViewClass, value, handler: handler)
  }
}
