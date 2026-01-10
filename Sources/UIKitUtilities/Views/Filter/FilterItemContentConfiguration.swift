//
//  FilterItemContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/15/25.
//

import UIKit

@available(iOS 15.0, *)
struct FilterItemContentConfiguration: UIContentConfiguration {

  let item: any FilterItem

  func makeContentView() -> any UIView & UIContentView {
    return FilterItemView(configuration: self)
  }

  func updated(for state: any UIConfigurationState) -> Self {
    return self
  }
}
