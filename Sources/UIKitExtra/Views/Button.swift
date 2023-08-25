//
//  Button.swift
//
//  Created by Sereivoan Yong on 5/18/21.
//

#if os(iOS)

import UIKit

@IBDesignable
open class Button: UIButton {

  open var contentAxis: NSLayoutConstraint.Axis = .horizontal {
    didSet {
      setNeedsLayout()
    }
  }

  @IBInspectable
  open var contentSpacing: CGFloat = 0 {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  @IBInspectable
  open var reversesContentPositioning: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }

  open override var intrinsicContentSize: CGSize {
    return intrinsicContentSize(within: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude))
  }

  private func intrinsicContentSize(within size: CGSize) -> CGSize {
    // See: https://stackoverflow.com/a/44264499/11235826
    var imageSize: CGSize?
    if currentImage != nil, let imageView = imageView {
      imageSize = imageView.sizeThatFits(size)
    }
    var titleSize: CGSize?
    if currentTitle != nil, let titleLabel = titleLabel {
      titleSize = titleLabel.sizeThatFits(size)
    }
    switch (imageSize, titleSize) {
    case (.some(let imageSize), .some(let titleSize)):
      switch contentAxis {
      case .vertical:
        return CGSize(width: max(imageSize.width, titleSize.width), height: imageSize.height + contentSpacing + titleSize.height)
      default:
        if contentAxis != .horizontal {
          print("Unsupported axis. `.horizontal` is used.")
        }
        return CGSize(width: imageSize.width + contentSpacing + titleSize.width, height: max(imageSize.height, titleSize.height))
      }
    case (.some(let imageSize), .none):
      return imageSize
    case (.none, .some(let titleSize)):
      return titleSize
    case (.none, .none):
      return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    if contentAxis == .vertical && currentTitle != nil, let titleLabel = titleLabel, titleLabel.textAlignment != .center {
      titleLabel.textAlignment = .center
    }
  }

  private enum HorizonalAlignmentSibling {

    case left(width: CGFloat)
    case right(width: CGFloat)
  }

  private func horizontalAlignment(_ contentHorizontalAlignment: ContentHorizontalAlignment, contentRect: CGRect, alignmentSize: inout CGSize, sibling: HorizonalAlignmentSibling? = nil) -> CGFloat {
    switch contentHorizontalAlignment {
    case .center:
      switch sibling {
      case .left(let leftWidth):
        let contentWidth = leftWidth + contentSpacing + alignmentSize.width
        return contentRect.minX + (contentRect.width - contentWidth) / 2 + (leftWidth + contentSpacing)
      case .right(let rightWidth):
        let contentWidth = alignmentSize.width + contentSpacing + rightWidth
        return contentRect.minX + (contentRect.width - contentWidth) / 2
      case nil:
        return contentRect.minX + (contentRect.width - alignmentSize.width) / 2
      }
    case .left:
      if case .left(let leftWidth) = sibling {
        return contentRect.minX + leftWidth + contentSpacing
      } else {
        return contentRect.minX
      }
    case .right:
      if case .right(let rightWidth) = sibling {
        let contentWidth = alignmentSize.width + contentSpacing + rightWidth
        return contentRect.maxX - contentWidth
      } else {
        return contentRect.maxX - alignmentSize.width
      }
    case .fill:
      alignmentSize.width = contentRect.width
      return contentRect.minX
    case .leading:
      fatalError()
    case .trailing:
      fatalError()
    @unknown default:
      return horizontalAlignment(.center, contentRect: contentRect, alignmentSize: &alignmentSize, sibling: sibling)
    }
  }

  private enum VerticalAlignmentSibling {

    case top(height: CGFloat)
    case bottom(height: CGFloat)
  }

  private func verticalAlignment(_ contentVerticalAlignment: ContentVerticalAlignment, contentRect: CGRect, alignmentSize: inout CGSize, sibling: VerticalAlignmentSibling? = nil) -> CGFloat {
    switch contentVerticalAlignment {
    case .center:
      switch sibling {
      case .top(let topHeight):
        let contentHeight = topHeight + contentSpacing + alignmentSize.height
        return contentRect.minY + (contentRect.height - contentHeight) / 2 + (topHeight + contentSpacing)
      case .bottom(let bottomHeight):
        let contentHeight = alignmentSize.height + contentSpacing + bottomHeight
        return contentRect.minY + (contentRect.height - contentHeight) / 2
      case nil:
        return contentRect.minY + (contentRect.height - alignmentSize.height) / 2
      }
    case .top:
      if case .top(let topHeight) = sibling {
        return contentRect.minY + topHeight + contentSpacing
      } else {
        return contentRect.minY
      }
    case .bottom:
      if case .bottom(let bottomHeight) = sibling {
        let contentHeight = alignmentSize.height + contentSpacing + bottomHeight
        return contentRect.maxY - contentHeight
      } else {
        return contentRect.maxY - alignmentSize.height
      }
    case .fill:
      alignmentSize.height = contentRect.height
      return contentRect.minY
    @unknown default:
      return verticalAlignment(.center, contentRect: contentRect, alignmentSize: &alignmentSize, sibling: sibling)
    }
  }

  open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    if value(forKey: "_titleView") == nil {
      return .zero
    }
    assert(currentTitle != nil)
    var titleSize = titleLabel!.sizeThatFits(contentRect.size)
    let imageSize = currentImage != nil ? imageView!.sizeThatFits(contentRect.size) : nil
    var x: CGFloat
    var y: CGFloat
    switch contentAxis {
    case .horizontal:
      if reversesContentPositioning {
        // Title left, image right
        x = horizontalAlignment(effectiveContentHorizontalAlignment, contentRect: contentRect, alignmentSize: &titleSize, sibling: imageSize.map { .right(width: $0.width) })
      } else {
        // Title right, image left
        x = horizontalAlignment(effectiveContentHorizontalAlignment, contentRect: contentRect, alignmentSize: &titleSize, sibling: imageSize.map { .left(width: $0.width) })
      }
      y = verticalAlignment(contentVerticalAlignment, contentRect: contentRect, alignmentSize: &titleSize)

    case .vertical:
      x = horizontalAlignment(effectiveContentHorizontalAlignment, contentRect: contentRect, alignmentSize: &titleSize)
      if reversesContentPositioning {
        // Title top, image bottom
        y = verticalAlignment(contentVerticalAlignment, contentRect: contentRect, alignmentSize: &titleSize, sibling: imageSize.map { .bottom(height: $0.height) })
      } else {
        // Title bottom, image top
        y = verticalAlignment(contentVerticalAlignment, contentRect: contentRect, alignmentSize: &titleSize, sibling: imageSize.map { .top(height: $0.height) })
      }

    default:
      fatalError()
    }
    return CGRect(origin: CGPoint(x: x, y: y), size: titleSize)
  }

  open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
    if value(forKey: "_imageView") == nil {
      return .zero
    }
    assert(currentImage != nil)
    let titleSize = currentTitle != nil ? titleLabel!.sizeThatFits(contentRect.size) : nil
    var imageSize = imageView!.sizeThatFits(contentRect.size)
    var x: CGFloat
    var y: CGFloat
    switch contentAxis {
    case .horizontal:
      if reversesContentPositioning {
        // Image right, title left
        x = horizontalAlignment(effectiveContentHorizontalAlignment, contentRect: contentRect, alignmentSize: &imageSize, sibling: titleSize.map { .left(width: $0.width) })
      } else {
        // Image left, title right
        x = horizontalAlignment(effectiveContentHorizontalAlignment, contentRect: contentRect, alignmentSize: &imageSize, sibling: titleSize.map { .right(width: $0.width) })
      }
      y = verticalAlignment(contentVerticalAlignment, contentRect: contentRect, alignmentSize: &imageSize)

    case .vertical:
      x = horizontalAlignment(effectiveContentHorizontalAlignment, contentRect: contentRect, alignmentSize: &imageSize)
      if reversesContentPositioning {
        // Image bottom, title top
        y = verticalAlignment(contentVerticalAlignment, contentRect: contentRect, alignmentSize: &imageSize, sibling: titleSize.map { .top(height: $0.height) })
      } else {
        // Image Top, title bottom
        y = verticalAlignment(contentVerticalAlignment, contentRect: contentRect, alignmentSize: &imageSize, sibling: titleSize.map { .bottom(height: $0.height) })
      }

    default:
      fatalError()
    }
    return CGRect(origin: CGPoint(x: x, y: y), size: imageSize)
  }
}

extension Button {

  @IBInspectable
  final public var isVertical: Bool {
    get { contentAxis == .vertical }
    set { contentAxis = newValue ? .vertical : .horizontal }
  }

  final public func setButtonType(_ buttonType: ButtonType) {
    setValue(buttonType.rawValue, forKey: "buttonType")
  }
}

#endif
