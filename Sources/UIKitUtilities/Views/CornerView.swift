//
//  CornerView.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 2/4/25.
//

extension CornerView {

  public enum CornerStyle {

    case fixed(CGFloat)
    case capsule

    public var isCapsule: Bool {
      if case .capsule = self {
        return true
      }
      return false
    }

    public func resolvedRadius(with rect: CGRect) -> CGFloat {
      switch self {
      case .fixed(let radius):
        return radius
      case .capsule:
        return rect.size.minDimension / 2
      }
    }
  }
}

open class CornerView: UIView {

  open var cornerStyle: CornerStyle = .fixed(0) {
    didSet {
      switch cornerStyle {
      case .fixed(let radius):
        layer.cornerRadius = radius
      case .capsule:
        layer.cornerRadius = frame.size.minDimension / 2
      }
    }
  }

  @IBInspectable open var isCapsule: Bool {
    get { return cornerStyle.isCapsule }
    set { cornerStyle = newValue ? .capsule : .fixed(0) }
  }

  open override var frame: CGRect {
    didSet {
      if case .capsule = cornerStyle {
        layer.cornerRadius = frame.size.minDimension / 2
      }
    }
  }
}
