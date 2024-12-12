//
//  AnyContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/27/25.
//

import UIKit
import SwiftKit

@available(iOS 14.0, *)
public protocol AnyContentConfiguration: UIContentConfiguration {

  typealias Handler = (UIView & UIContentView, Self) -> Void

  var contentViewClass: (UIView & UIContentView).Type { get }

  var handler: Handler { get }
}

@available(iOS 14.0, *)
extension AnyContentConfiguration {

  @MainActor public func makeContentView() -> UIView & UIContentView {
    let contentView: UIView & UIContentView
    if let contentViewClass = contentViewClass as? (UIView & NibLoadable).Type {
      contentView = contentViewClass.loadFromNib() as! UIView & UIContentView
    } else {
      contentView = contentViewClass.init()
    }
    handler(contentView, self)
    return contentView
  }

  public func updated(for state: any UIConfigurationState) -> Self {
    return self
  }
}
