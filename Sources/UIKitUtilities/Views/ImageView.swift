//
//  ImageView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 10/8/26.
//

import UIKit

open class ImageView: UIImageView {

  open var preferredSize: CGSize? {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  open override var intrinsicContentSize: CGSize {
    return preferredSize ?? super.intrinsicContentSize
  }
}
