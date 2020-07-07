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
  
  final public func reverseImageAndTitleHorizontally(spacing: CGFloat) {
    sizeToFit()
    let titleWidth = titleRect(forContentRect: bounds).width
    let imageWidth = imageRect(forContentRect: bounds).width
    let dx = spacing / 2
    titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - dx, bottom: 0, right: imageWidth + dx)
    imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth + dx, bottom: 0, right: -titleWidth - dx)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: dx)
  }
  
  final public func setSpacingBetweenImageAndTitle(_ spacing: CGFloat) {
    let dx = spacing / 2
    titleEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: -dx)
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -dx, bottom: 0, right: dx)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: dx)
  }
  
  final public func setTitle(_ title: String?, for state: State, animated: Bool) {
    if animated {
      setTitle(title, for: state)
    } else {
      UIView.performWithoutAnimation {
        setTitle(title, for: state)
        layoutIfNeeded()
      }
    }
  }
  
  @inlinable public convenience init(type: ButtonType, target: AnyObject? = nil, action: Selector? = nil) {
    self.init(type: type)
    if let action = action {
      addTarget(target, action: action, for: .touchUpInside)
    }
  }
  
  public static func system(image: UIImage? = nil, title: String? = nil, target: AnyObject? = nil, action: Selector? = nil) -> UIButton {
    let button = UIButton(type: .system, target: target, action: action)
    button.setImage(image, for: .normal)
    button.setTitle(title, for: .normal)
    return button
  }
}
#endif
