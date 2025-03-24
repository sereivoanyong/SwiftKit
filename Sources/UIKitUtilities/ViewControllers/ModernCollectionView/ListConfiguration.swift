//
//  ViewData.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/9/24.
//

import UIKit
import SwiftKit

@available(iOS 15.0, *)
public struct ListConfiguration {

  public var content: UIContentConfiguration?
  public var background: UIBackgroundConfiguration?
  public var accessories: [UICellAccessory]

  public init(content: UIContentConfiguration? = nil, background: UIBackgroundConfiguration? = nil, accessories: [UICellAccessory] = []) {
    self.content = content
    self.background = background
    self.accessories = accessories
  }
}

@available(iOS 15.0, *)
extension UICollectionViewListCell {

  public func apply(_ configuration: ListConfiguration?) {
    if let configuration {
      contentConfiguration = configuration.content ?? defaultContentConfiguration()
      backgroundConfiguration = configuration.background ?? defaultBackgroundConfigurationIfAvailable()
      accessories = configuration.accessories
    } else {
      contentConfiguration = defaultContentConfiguration()
      backgroundConfiguration = defaultBackgroundConfigurationIfAvailable()
      accessories = []
    }
  }
}

extension UICollectionViewCell {

  @available(iOS 14.0, *)
  @inlinable
  func defaultBackgroundConfigurationIfAvailable() -> UIBackgroundConfiguration? {
    if #available(iOS 16.0, *) {
      return defaultBackgroundConfiguration()
    } else {
      return nil
    }
  }
}

@available(iOS 15.0, *)
public struct ListSection<ID: Hashable>: Identifiable {

  public let id: ID
  public var headerConfiguration: ListConfiguration?
  public var footerConfiguration: ListConfiguration?

  public init(id: ID, headerConfiguration: ListConfiguration? = nil, footerConfiguration: ListConfiguration? = nil) {
    self.id = id
    self.headerConfiguration = headerConfiguration
    self.footerConfiguration = footerConfiguration
  }
}

@available(iOS 15.0, *)
public struct ListItem<ID: Hashable>: Identifiable {

  public let id: ID
  public var configuration: ListConfiguration

  public init(id: ID, configuration: ListConfiguration) {
    self.id = id
    self.configuration = configuration
  }

  public init(configuration: ListConfiguration) where ID == UUID {
    self.id = UUID()
    self.configuration = configuration
  }
}
