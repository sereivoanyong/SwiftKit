//
//  AnyViewModelContentConfiguration.swift
//
//  Created by Sereivoan Yong on 9/9/24.
//

import UIKit

@available(iOS 14.0, *)
open class AnyViewModelContentConfiguration<ViewModel>: UIContentConfiguration {

  open var viewModel: ViewModel

  public init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }

  open func makeContentView() -> UIView & UIContentView {
    fatalError()
  }

  open func updated(for state: UIConfigurationState) -> Self {
    return self
  }
}
