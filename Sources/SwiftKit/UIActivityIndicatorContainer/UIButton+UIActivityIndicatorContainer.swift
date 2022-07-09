//
//  UIButton+UIActivityIndicatorContainer.swift
//  TongTin
//
//  Created by Sereivoan Yong on 7/3/22.
//

import UIKit

@available(iOS 15.0, *)
private var configurationBeforeActivityIndicatorViewKey: Void?

private var contentBeforeActivityIndicatorViewKey: Void?

extension UIButton: UIActivityIndicatorContainer {

  public var containerViewForActivityIndicator: UIView? {
    return self
  }

  public typealias Content = (UIImage?, String?)

  @available(iOS 15.0, *)
  public private(set) var configurationBeforeActivityIndicator: Configuration? {
    get { return associatedValue(forKey: &configurationBeforeActivityIndicatorViewKey) }
    set { setAssociatedValue(newValue, forKey: &configurationBeforeActivityIndicatorViewKey) }
  }

  public private(set) var contentBeforeActivityIndicator: Content? {
    get { return associatedValue(forKey: &contentBeforeActivityIndicatorViewKey) }
    set { setAssociatedValue(newValue, forKey: &contentBeforeActivityIndicatorViewKey) }
  }

  public func willShowActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView) {
    if #available(iOS 15.0, *), let configuration = configuration {
      configurationBeforeActivityIndicator = configuration
      var newConfiguration = configuration
      newConfiguration.imageColorTransformer = .init({ _ in .clear })
      let clearTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ $0.merging(.init([.foregroundColor: UIColor.clear])) })
      newConfiguration.titleTextAttributesTransformer = clearTextAttributesTransformer
      newConfiguration.subtitleTextAttributesTransformer = clearTextAttributesTransformer
      self.configuration = newConfiguration
    } else {
      let image = image(for: .normal)
      let title = title(for: .normal)
      contentBeforeActivityIndicator = (image, title)
      setImage(nil, for: .normal)
      setTitle(nil, for: .normal)
    }
  }

  public func willHideActivityIndicator(_ activityIndicatorView: UIActivityIndicatorView) {
    if #available(iOS 15.0, *), configuration != nil {
      configuration = configurationBeforeActivityIndicator
      configurationBeforeActivityIndicator = nil
    } else {
      if let (image, title) = contentBeforeActivityIndicator {
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        contentBeforeActivityIndicator = nil
      }
    }
  }
}
