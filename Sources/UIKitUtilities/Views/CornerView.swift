//
//  CornerView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 2/4/25.
//

import UIKit
import SwiftKit

open class CornerView: UIView {

  open var cornerStyle: CornerStyle = .fixed(0) {
    didSet {
      layer.cornerRadius = cornerStyle.resolvedRadius(with: frame)
    }
  }

  @IBInspectable open var isCapsule: Bool {
    get { return cornerStyle.isCapsule }
    set { cornerStyle = newValue ? .capsule : .fixed(0) }
  }

  open override var frame: CGRect {
    didSet {
      if case .fractional(let fraction) = cornerStyle {
        let frame = frame
        layer.cornerRadius = min(frame.width, frame.height) * fraction
      }
    }
  }
}
