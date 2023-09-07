//
//  StackView.swift
//
//  Created by Sereivoan Yong on 3/2/21.
//

import UIKit
import SwiftKit

extension StackView {

  // Raw value is important. Do not change.
  public enum SeparatorInsetReference: Int {

    case fromEdges = 0

    case fromSafeArea = 1

    case fromLayoutMargins = 2
  }
}

@IBDesignable
open class StackView: UIStackView {

  open private(set) var separatorViews: [SeparatorView] = []

  open var separatorViewProvider: () -> SeparatorView = {
    return SeparatorView()
  }

  open var separatorInsets: UIEdgeInsets = .zero

  open var separatorInsetReference: SeparatorInsetReference = .fromEdges

  open override var spacing: CGFloat {
    get { return super.spacing }
    set {
      if Int(newValue / traitCollection.displayPointPerPixel) % 2 == 1 {
        super.spacing = newValue
      } else {
        super.spacing = newValue + traitCollection.displayPointPerPixel
      }
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    layoutSeparatorViews()
  }

  private func layoutSeparatorViews() {
    let arrangedSubviews = arrangedSubviews
    guard arrangedSubviews.count > 1 else {
      if !separatorViews.isEmpty {
        for separatorView in separatorViews {
          separatorView.removeFromSuperview()
        }
        separatorViews.removeAll()
      }
      return
    }

    let countToAdd = arrangedSubviews.count - 1 - separatorViews.count
    if countToAdd > 0 {
      for _ in 0..<countToAdd {
        let separatorView = separatorViewProvider()
        separatorView.axis.isVertical = !axis.isVertical
        addSubview(separatorView)
        separatorViews.append(separatorView)
      }
    } else if countToAdd < 0 {
      let countToRemove = -countToAdd
      for separatorView in separatorViews[(separatorViews.count - 1 - countToRemove)...] {
        separatorView.removeFromSuperview()
      }
      separatorViews.removeLast(countToRemove)
    }

    precondition(separatorViews.count == arrangedSubviews.count - 1)

    let referenceInsets: UIEdgeInsets
    switch separatorInsetReference {
    case .fromEdges:
      referenceInsets = .zero
    case .fromSafeArea:
      referenceInsets = safeAreaInsets
    case .fromLayoutMargins:
      referenceInsets = layoutMargins
    }
    var insets = separatorInsets
    insets = UIEdgeInsets(top: insets.top + referenceInsets.top, left: insets.left + referenceInsets.left, bottom: insets.bottom + referenceInsets.bottom, right: insets.right + referenceInsets.right)

    let frameProvider: (SeparatorView, UIView, UIView) -> CGRect
    switch axis {
    case .vertical:
      frameProvider = { [unowned self] separatorView, topView, bottomView in
        var size = CGSize(width: bounds.width - insets.horizontal, height: bottomView.frame.minY - topView.frame.maxY)
        size.height = separatorView.sizeThatFits(size).height
        let y = topView.frame.maxY + ((bottomView.frame.minY - size.height - topView.frame.maxY) / 2).flooredToPixel(scale: traitCollection.displayScale)
        return CGRect(origin: CGPoint(x: insets.left, y: y), size: size)
      }
    default:
      frameProvider = { [unowned self] separatorView, leftView, rightView in
        var size = CGSize(width: rightView.frame.minX - leftView.frame.maxX, height: bounds.height - insets.vertical)
        size.width = separatorView.sizeThatFits(size).width
        let x = leftView.frame.maxX + ((rightView.frame.minX - size.width - leftView.frame.maxX) / 2).flooredToPixel(scale: traitCollection.displayScale)
        return CGRect(origin: CGPoint(x: x, y: insets.top), size: size)
      }
    }

    for (index, arrangedSubview) in arrangedSubviews.dropLast().enumerated() {
      let separatorView = separatorViews[index]
      separatorView.frame = frameProvider(separatorView, arrangedSubview, arrangedSubviews[index + 1])
    }
  }
}

extension StackView {

  @IBInspectable
  public var separatorInsetReferenceRaw: Int {
    get { return separatorInsetReference.rawValue }
    set { separatorInsetReference = SeparatorInsetReference(rawValue: newValue) ?? .fromEdges }
  }
}
