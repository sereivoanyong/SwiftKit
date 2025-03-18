//
//  ObjectContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
public struct ObjectContentConfiguration<Object>: UIContentConfiguration {

  public let contentViewClass: (UIView & UIContentView).Type

  public let object: Object

  @MainActor public let handler: (UIView & UIContentView, Self) -> Void

  @MainActor public init<ContentView: ObjectContentView<Object>>(_ contentViewClass: ContentView.Type, object: Object, handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }) {
    self.contentViewClass = contentViewClass
    self.object = object
    self.handler = { contentView, configuration in
      handler(contentView as! ContentView, configuration)
    }
  }

  @MainActor public func makeContentView() -> UIView & UIContentView {
    // `any ObjectContentView<Object>` requires iOS 16 runtime.
    let contentView: UIView & UIContentView
    if let contentViewClass = contentViewClass as? (UIView & NibLoadable).Type {
      contentView = contentViewClass.loadFromNib() as! UIView & UIContentView
    } else {
      contentView = contentViewClass.init()
    }
    // At least check if content view supports the configuration since we cannot declare content view as `any ObjectContentView<Object>`
    if #available(iOS 16.0, *) {
      assert(contentView.supports(self))
    }
    handler(contentView, self)
    return contentView
  }

  public func updated(for state: any UIConfigurationState) -> Self {
    return self
  }
}

@available(iOS 14.0, *)
extension ObjectContentConfiguration: Equatable where Object: Equatable {

  public static func == (lhs: ObjectContentConfiguration<Object>, rhs: ObjectContentConfiguration<Object>) -> Bool {
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
