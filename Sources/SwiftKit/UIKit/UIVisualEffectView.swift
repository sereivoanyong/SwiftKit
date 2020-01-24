//
//  UIVisualEffectView.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIVisualEffectView {
  
  public convenience init(blurEffectStyle: UIBlurEffect.Style) {
    self.init(effect: UIBlurEffect(style: blurEffectStyle))
  }
  
  @available(iOS 13.0, *)
  public convenience init(blurEffectStyle: UIBlurEffect.Style, vibrancyEffectStyle: UIVibrancyEffectStyle, view: UIView) {
    let blurEffect = UIBlurEffect(style: blurEffectStyle)
    self.init(blurEffect: blurEffect, vibrancyEffect: UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyEffectStyle), view: view)
  }
  
  public convenience init(blurEffect: UIBlurEffect, vibrancyEffect: UIVibrancyEffect?, view: UIView) {
    precondition(!view.translatesAutoresizingMaskIntoConstraints)
    let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect ?? UIVibrancyEffect(blurEffect: blurEffect))
    vibrancyEffectView.contentView.addSubview(view)
    vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: vibrancyEffectView.contentView.topAnchor),
      view.leftAnchor.constraint(equalTo: vibrancyEffectView.contentView.leftAnchor),
      vibrancyEffectView.contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      vibrancyEffectView.contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
    ])
    
    self.init(effect: blurEffect)
    contentView.addSubview(vibrancyEffectView)
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      vibrancyEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
      vibrancyEffectView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      contentView.bottomAnchor.constraint(equalTo: vibrancyEffectView.bottomAnchor),
      contentView.rightAnchor.constraint(equalTo: vibrancyEffectView.rightAnchor),
    ])
  }
}
#endif
