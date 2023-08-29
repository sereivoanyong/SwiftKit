//
//  NSStringDrawing.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension String {

  // MARK: StringDrawing

  public func size(withAttributes attributes: [NSAttributedString.Key: Any]) -> CGSize {
    return (self as NSString).size(withAttributes: attributes)
  }

  public func draw(at point: CGPoint, withAttributes attributes: [NSAttributedString.Key: Any]) {
    (self as NSString).draw(at: point, withAttributes: attributes)
  }

  public func draw(in rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]) {
    (self as NSString).draw(in: rect, withAttributes: attributes)
  }

  // MARK: ExtendedStringDrawing

  public func draw(with rect: CGRect, options: NSStringDrawingOptions, attributes: [NSAttributedString.Key: Any], context: NSStringDrawingContext? = nil) {
    (self as NSString).draw(with: rect, options: options, attributes: attributes, context: context)
  }

  public func boundingRect(with size: CGSize, options: NSStringDrawingOptions, attributes: [NSAttributedString.Key: Any], context: NSStringDrawingContext? = nil) -> CGRect {
    return (self as NSString).boundingRect(with: size, options: options, attributes: attributes, context: context)
  }

  // MARK: Convenience

  public func sizeThatFits(_ size: CGSize, options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key: Any]) -> CGSize {
    return boundingRect(with: size, options: options, attributes: attributes).size
  }

  public func sizeThatFits(width: CGFloat?, options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key: Any]) -> CGSize {
    if let width {
      let height = boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: options, attributes: attributes).height
      return CGSize(width: width, height: height)
    } else {
      return size(withAttributes: attributes)
    }
  }

  public func heightThatFits(width: CGFloat, options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key: Any]) -> CGFloat {
    return sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude), options: options, attributes: attributes).height
  }

  public func heightThatFits(width: CGFloat, options: NSStringDrawingOptions, font: UIFont, limitedToNumberOfLines numberOfLines: Int) -> CGFloat {
    return min(font.lineHeight(numberOfLines: numberOfLines), heightThatFits(width: .greatestFiniteMagnitude, options: options, attributes: [.font: font]))
  }
}

extension NSAttributedString {

  public func sizeThatFits(width: CGFloat?) -> CGSize {
    if let width {
      let height = boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height
      return CGSize(width: width, height: height)
    } else {
      return size()
    }
  }

  // MARK: Convenience

  public func sizeThatFits(_ size: CGSize, options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]) -> CGSize {
    return boundingRect(with: size, options: options, context: nil).size
  }

  public func heightThatFits(width: CGFloat, options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]) -> CGFloat {
    return sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude), options: options).height
  }
}
