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

  public var content: (any UIContentConfiguration)?
  public var background: UIBackgroundConfiguration?
  public var accessories: [UICellAccessory]

  public init(content: (any UIContentConfiguration)? = nil, background: UIBackgroundConfiguration? = nil, accessories: [UICellAccessory] = []) {
    self.content = content
    self.background = background
    self.accessories = accessories
  }
}

@available(iOS 15.0, *)
extension UICollectionViewCell {
  
  public func apply(_ configuration: ListConfiguration?) {
    if let configuration {
      if let cell = self as? UICollectionViewListCell {
        cell.contentConfiguration = configuration.content ?? cell.defaultContentConfiguration()
        cell.backgroundConfiguration = configuration.background ?? defaultBackgroundConfigurationIfAvailable()
        cell.accessories = configuration.accessories
      } else {
        contentConfiguration = configuration.content
        backgroundConfiguration = configuration.background ?? defaultBackgroundConfigurationIfAvailable()
        assert(configuration.accessories.isEmpty, "Cell does not support accessories.")
      }
    } else {
      contentConfiguration = nil
      backgroundConfiguration = nil
      if let cell = self as? UICollectionViewListCell {
        cell.accessories = []
      }
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
  public var headerConfiguration: () -> ListConfiguration?
  public var footerConfiguration: () -> ListConfiguration?

  public init(id: ID, headerConfiguration: @autoclosure @escaping () -> ListConfiguration? = nil, footerConfiguration: @autoclosure @escaping () -> ListConfiguration? = nil) {
    self.id = id
    self.headerConfiguration = headerConfiguration
    self.footerConfiguration = footerConfiguration
  }
}

@available(iOS 15.0, *)
public struct ListItem<ID: Hashable>: Identifiable {

  public let id: ID
  public var configuration: () -> ListConfiguration?

  public init(id: ID, configuration: @autoclosure @escaping () -> ListConfiguration) {
    self.id = id
    self.configuration = configuration
  }

  public init(configuration: @autoclosure @escaping () -> ListConfiguration) where ID == UUID {
    self.id = UUID()
    self.configuration = configuration
  }
}
