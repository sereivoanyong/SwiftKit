//
//  BarPositioning.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 5/19/25.
//

import UIKit
import SwiftKit

public protocol BarPositioning: UIView {

  var barPosition: BarPosition { get }
}

public enum BarPosition: String {

  case top, leading, bottom, trailing
}

@available(iOS 13.0, *)
open class BarBackgroundView: UIView {

  open var barPosition: BarPosition? {
    didSet {
      if let barPosition {
        sy.addBarShadowView(thickness: 1, for: barPosition)
      } else {
        sy.removeBarShadowView()
      }
    }
  }

  @IBInspectable
  open var barPositionRaw: String? {
    get { return barPosition?.rawValue }
    set { barPosition = newValue.flatMap(BarPosition.init(rawValue:)) }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .systemBackground
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

extension UIView: SYCompatible { }
