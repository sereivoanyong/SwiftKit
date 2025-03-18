//
//  ObjectContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
public struct ObjectContentConfiguration<Object: AnyObject>: AnyContentConfiguration {

  public let contentViewClass: (UIView & UIContentView).Type

  public let object: Object

  @MainActor public var handler: Handler
  
  @MainActor public init<ContentView: ObjectContentView<Object>>(
    _ contentViewClass: ContentView.Type,
    _ object: Object,
    handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }
  ) {
    self.object = object
    self.contentViewClass = contentViewClass
    self.handler = { contentView, configuration in
      handler(contentView as! ContentView, configuration)
    }
  }
}

@available(iOS 14.0, *)
extension ObjectContentConfiguration: Equatable where Object: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.object == rhs.object && lhs.contentViewClass == rhs.contentViewClass
  }
}

@available(iOS 14.0, *)
extension ObjectContentConfiguration: Hashable where Object: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(object)
    hasher.combine(ObjectIdentifier(contentViewClass))
  }
}

@available(iOS 14.0, *)
extension UIContentConfiguration {

  @inlinable
  @MainActor public static func object<Object: AnyObject, ContentView: ObjectContentView<Object>>(
    _ contentViewClass: ContentView.Type,
    _ object: Object,
    handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }
  ) -> Self where Self == ObjectContentConfiguration<Object> {
    return .init(contentViewClass, object, handler: handler)
  }
}
