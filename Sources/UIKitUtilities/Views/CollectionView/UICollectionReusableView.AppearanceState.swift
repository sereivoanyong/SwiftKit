//
//  UICollectionReusableView.AppearanceState.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/24/24.
//

import UIKit

extension UICollectionReusableView {

  public enum AppearanceState {

    case none
    case willDisplay
    case didEndDisplaying
  }
}

public protocol AppearingCollectionReusableView: UICollectionReusableView {

  var appearanceState: AppearanceState { get set }
}

public protocol AppearingCollectionReusableViewSubview: UIView {

  func parentReusableViewAppearanceStateDidChange(_ parentReusableView: AppearingCollectionReusableView)
}
