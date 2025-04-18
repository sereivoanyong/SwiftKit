//
//  ContentView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/27/25.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
@MainActor public protocol ContentView<Configuration>: UIView, UIContentView {

  associatedtype Configuration: UIContentConfiguration

  @MainActor func configure(_ configuration: Configuration)
}

private var configurationKey: Void?

@available(iOS 14.0, *)
extension ContentView {

  @MainActor var _configurationIfSet: Configuration? {
    return associatedValue(forKey: &configurationKey, with: self)
  }

  @MainActor public var _configuration: Configuration {
    get {
      return associatedValue(forKey: &configurationKey, with: self)!
    }
    set {
      setAssociatedValue(newValue, forKey: &configurationKey, with: self)
      configure(newValue)
    }
  }

  @MainActor public var configuration: UIContentConfiguration {
    get {
      return associatedValue(forKey: &configurationKey, with: self)!
    }
    set {
      setAssociatedValue(newValue, forKey: &configurationKey, with: self)
      if let newValue = newValue as? Configuration {
        configure(newValue)
      }
    }
  }

  @MainActor public func supports(_ configuration: UIContentConfiguration) -> Bool {
    return configuration is Configuration
  }
}
