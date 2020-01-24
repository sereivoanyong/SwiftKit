//
//  UIImageView.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

#if canImport(UIKit)
import UIKit

extension UIImageView {
  
  public static func templateRendered(image: UIImage, tintColor: UIColor) -> UIImageView {
    let imageView = UIImageView()
    if image.renderingMode == .alwaysTemplate {
      imageView.image = image
    } else {
      imageView.image = image.withRenderingMode(.alwaysTemplate)
    }
    imageView.tintColor = tintColor
    return imageView
  }
}
#endif
