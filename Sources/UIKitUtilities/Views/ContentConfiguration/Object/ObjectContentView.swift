//
//  ObjectContentView.swift
//
//  Created by Sereivoan Yong on 9/16/24.
//

import UIKit

@available(iOS 14.0, *)
public protocol ObjectContentView: UIView, UIContentView {

  associatedtype Object

  var objectConfiguration: AnyObjectContentConfiguration<Object>! { get set }

  func configure(_ object: Object)
}

private var _configurationKey: Void?

@available(iOS 14.0, *)
extension ObjectContentView {

  public typealias Configuration = ObjectContentConfiguration<Self>

  public var configuration: UIContentConfiguration {
    get { return objectConfiguration }
    set { objectConfiguration = newValue as? AnyObjectContentConfiguration<Object> }
  }

  public var objectConfiguration: AnyObjectContentConfiguration<Object>! {
    get { return associatedObject(forKey: &_configurationKey, with: self) }
    set {
      setAssociatedObject(newValue, forKey: &_configurationKey, with: self)
      configure(newValue.object)
    }
  }

  public func supports(_ configuration: UIContentConfiguration) -> Bool {
    return configuration is AnyObjectContentConfiguration<Object>
  }
}
