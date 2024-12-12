//
//  ViewModelConfiguring.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/24/25.
//

public protocol ViewModelConfiguring<ViewModel>: AnyObject {

  associatedtype Object

  associatedtype ViewModel: ObjectViewModelProtocol<Object>

  var viewModel: ViewModel! { get set }

  func configure(_ viewModel: ViewModel)
}
