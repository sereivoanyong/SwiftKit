//
//  ViewModelContentView.swift
//
//  Created by Sereivoan Yong on 9/9/24.
//

import UIKit

@available(iOS 14.0, *)
public protocol ViewModelContentView: UIView, UIContentView {

  associatedtype ViewModel

  var viewModelConfiguration: AnyViewModelContentConfiguration<ViewModel>! { get set }
}

@available(iOS 14.0, *)
extension ViewModelContentView {

  public typealias Configuration = ViewModelContentConfiguration<Self>

  public var configuration: UIContentConfiguration {
    get { return viewModelConfiguration }
    set { viewModelConfiguration = newValue as? AnyViewModelContentConfiguration<ViewModel> }
  }

  public func supports(_ configuration: UIContentConfiguration) -> Bool {
    return configuration is AnyViewModelContentConfiguration<ViewModel>
  }
}
