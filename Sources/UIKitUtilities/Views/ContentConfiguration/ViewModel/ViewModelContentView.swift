//
//  ViewModelContentView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/9/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
@MainActor public protocol ViewModelContentView<ViewModel>: ContentView where Configuration == ViewModelContentConfiguration<ViewModel> {

  associatedtype ViewModel: AnyObject

  @MainActor func configure(_ viewModel: ViewModel)
}

@available(iOS 14.0, *)
extension ViewModelContentView {

  public var configurationViewModel: ViewModel! {
    return _configurationIfSet?.viewModel
  }

  @MainActor public func configure(_ configuration: ViewModelContentConfiguration<ViewModel>) {
    configure(configuration.viewModel)
  }
}
