//
//  ViewModelContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/9/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
public struct ViewModelContentConfiguration<ViewModel: AnyObject>: AnyContentConfiguration {

  public let contentViewClass: (UIView & UIContentView).Type
  
  public let viewModel: ViewModel

  @MainActor public var handler: Handler

  @MainActor public init<ContentView: ViewModelContentView<ViewModel>>(
    _ contentViewClass: ContentView.Type,
    _ viewModel: ViewModel,
    handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }
  ) {
    self.viewModel = viewModel
    self.contentViewClass = contentViewClass
    self.handler = { contentView, configuration in
      handler(contentView as! ContentView, configuration)
    }
  }
}

@available(iOS 14.0, *)
extension ViewModelContentConfiguration: Equatable where ViewModel: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.viewModel == rhs.viewModel && lhs.contentViewClass == rhs.contentViewClass
  }
}

@available(iOS 14.0, *)
extension ViewModelContentConfiguration: Hashable where ViewModel: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(viewModel)
    hasher.combine(ObjectIdentifier(contentViewClass))
  }
}

@available(iOS 14.0, *)
extension UIContentConfiguration {

  @inlinable
  @MainActor public static func viewModel<ViewModel: AnyObject, ContentView: ViewModelContentView<ViewModel>>(
    _ contentViewClass: ContentView.Type,
    _ viewModel: ViewModel,
    handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }
  ) -> Self where Self == ViewModelContentConfiguration<ViewModel> {
    return .init(contentViewClass, viewModel, handler: handler)
  }
}
