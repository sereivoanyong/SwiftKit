//
//  UIContentConfiguration.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 3/24/25.
//

import UIKit

@available(iOS 14.0, *)
extension UIContentConfiguration {

  public static func list(_ base: UIListContentConfiguration, image: UIImage? = nil, text: String? = nil, secondaryText: String? = nil) -> Self where Self == UIListContentConfiguration {
    var configuration = base
    configuration.image = image
    configuration.text = text
    configuration.secondaryText = secondaryText
    return configuration
  }
}
