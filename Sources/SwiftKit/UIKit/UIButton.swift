//
//  UIButton.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIButton {

  /// Sets the background image from color to use for the specified button state
  public func setBackgroundImage(color: UIColor?, cornerRadius: CGFloat = 0, renderingMode: UIImage.RenderingMode? = nil, for state: State) {
    guard let color else {
      setBackgroundImage(nil, for: state)
      return
    }
    var backgroundImage = UIImage(color: color, size: CGSize(dimension: cornerRadius * 2), cornerRadius: cornerRadius).resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    if let renderingMode {
      backgroundImage = backgroundImage.withRenderingMode(renderingMode)
    }
    setBackgroundImage(backgroundImage, for: state)
  }

  public func reverseImageAndTitleHorizontally(spacing: CGFloat) {
    sizeToFit()
    let titleWidth = titleRect(forContentRect: bounds).width
    let imageWidth = imageRect(forContentRect: bounds).width
    let dx = spacing / 2
    titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - dx, bottom: 0, right: imageWidth + dx)
    imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth + dx, bottom: 0, right: -titleWidth - dx)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: dx)
  }

  public func setSpacingBetweenImageAndTitle(_ spacing: CGFloat) {
    let dx = spacing / 2
    titleEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: -dx)
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -dx, bottom: 0, right: dx)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: dx, bottom: 0, right: dx)
  }

  public func setTitle(_ title: String?, for state: State, animated: Bool) {
    if animated {
      setTitle(title, for: state)
    } else {
      UIView.performWithoutAnimation {
        setTitle(title, for: state)
        layoutIfNeeded()
      }
    }
  }

  @inlinable
  public convenience init(type: ButtonType = .custom, image: UIImage? = nil, title: String? = nil, target: AnyObject? = nil, action: Selector? = nil) {
    self.init(type: type)
    setImage(image, for: .normal)
    setTitle(title, for: .normal)
    if let target, let action {
      addTarget(target, action: action, for: .touchUpInside)
    }
  }

  public convenience init(type: ButtonType, primaryAction: Action?) {
    self.init(type: type)
    bc.primaryAction = primaryAction
  }

  override func bc_setPrimaryAction(_ primaryAction: Action?) {
    setTitle(primaryAction?.title, for: .normal)
    setImage(primaryAction?.image, for: .normal)
  }
}
#endif
