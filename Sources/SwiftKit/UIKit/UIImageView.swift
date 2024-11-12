//
//  UIImageView.swift
//
//  Created by Sereivoan Yong on 1/25/20.
//

import UIKit

extension UIImageView {

  @inlinable
  public convenience init(image: UIImage? = nil, highlightedImage: UIImage? = nil, contentMode: ContentMode, tintColor: UIColor? = nil) {
    self.init(frame: .zero)
    self.image = image
    self.highlightedImage = highlightedImage
    self.contentMode = contentMode
    self.tintColor = tintColor
  }
  
  public static func templateRendered(image: UIImage, contentMode: ContentMode, tintColor: UIColor? = nil) -> UIImageView {
    let imageView = UIImageView()
    if image.renderingMode == .alwaysTemplate {
      imageView.image = image
    } else {
      imageView.image = image.withRenderingMode(.alwaysTemplate)
    }
    imageView.contentMode = contentMode
    imageView.tintColor = tintColor
    return imageView
  }
}
