//
//  UIButton.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIButton {
  
  /// Sets the background image from color to use for the specified button state
  final public func setBackgroundImage(color: UIColor?, cornerRadius: CGFloat = 0, renderingMode: UIImage.RenderingMode? = nil, for state: State) {
    guard let color = color else {
      setBackgroundImage(nil, for: state)
      return
    }
    var backgroundImage = UIImage(color: color, size: CGSize(dimension: cornerRadius * 2), cornerRadius: cornerRadius).resizableImage(withCapInsets: UIEdgeInsets(inset: cornerRadius))
    if let renderingMode = renderingMode {
      backgroundImage = backgroundImage.withRenderingMode(renderingMode)
    }
    setBackgroundImage(backgroundImage, for: state)
  }
  
  final public func setSpacingBetweenImageTitle(_ spacing: CGFloat) {
    let dx = spacing / 2
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -dx, bottom: 0, right: dx)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: -dx)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: dx)
  }
  
  public static func system(image: UIImage? = nil, title: String? = nil, target: AnyObject, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(image, for: .normal)
    button.setTitle(title, for: .normal)
    button.addTarget(target, action: action, for: .touchUpInside)
    return button
  }
}
#endif
