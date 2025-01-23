//
//  ViewModelContentView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 9/9/24.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
@MainActor public protocol ViewModelContentView<ViewModel>: UIView, UIContentView {

  associatedtype ViewModel

  @MainActor var viewModelConfiguration: ViewModelContentConfiguration<ViewModel> { get set }

  @MainActor func configure(_ viewModel: ViewModel)
}

private var __configurationKey: Void?

@available(iOS 14.0, *)
extension ViewModelContentView {

  @MainActor public var __configuration: UIContentConfiguration? {
    get { return associatedValue(forKey: &__configurationKey, with: self) }
    set { setAssociatedValue(newValue, forKey: &__configurationKey, with: self) }
  }

  @MainActor public var configuration: UIContentConfiguration {
    get { return __configuration! }
    set {
      __configuration = newValue
      if let newValue = newValue as? ViewModelContentConfiguration<ViewModel> {
        configure(newValue.viewModel)
      }
    }
  }

  @inlinable
  @MainActor public var viewModelConfiguration: ViewModelContentConfiguration<ViewModel> {
    get { return __configuration as! ViewModelContentConfiguration<ViewModel> }
    set {
      __configuration = newValue
      configure(newValue.viewModel)
    }
  }

  @inlinable
  public var viewModel: ViewModel {
    return viewModelConfiguration.viewModel
  }

  @MainActor public func supports(_ configuration: UIContentConfiguration) -> Bool {
    return configuration is ViewModelContentConfiguration<ViewModel>
  }
}
