//
//  ViewModelContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/9/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
public struct ViewModelContentConfiguration<ViewModel>: UIContentConfiguration {

  public let contentViewClass: (UIView & UIContentView).Type

  public let viewModel: ViewModel
  
  @MainActor public let handler: (UIView & UIContentView, Self) -> Void

  @MainActor public init<ContentView: ViewModelContentView<ViewModel>>(_ contentViewClass: ContentView.Type, viewModel: ViewModel, handler: @escaping @MainActor (ContentView, Self) -> Void = { $0.configuration = $1 }) {
    self.contentViewClass = contentViewClass
    self.viewModel = viewModel
    self.handler = { contentView, configuration in
      handler(contentView as! ContentView, configuration)
    }
  }

  @MainActor public func makeContentView() -> UIView & UIContentView {
    // `any ViewModelContentView<Object>` requires iOS 16 runtime.
    let contentView: UIView & UIContentView
    if let contentViewClass = contentViewClass as? (UIView & NibLoadable).Type {
      contentView = contentViewClass.loadFromNib() as! UIView & UIContentView
    } else {
      contentView = contentViewClass.init()
    }
    // At least check if content view supports the configuration since we cannot declare content view as `any ViewModelContentView<Object>`
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
extension ViewModelContentConfiguration: Equatable where ViewModel: Equatable {

  public static func == (lhs: ViewModelContentConfiguration<ViewModel>, rhs: ViewModelContentConfiguration<ViewModel>) -> Bool {
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
