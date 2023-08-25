//
//  ContentScrollView.swift
//
//  Created by Sereivoan Yong on 5/4/21.
//

#if os(iOS)

import UIKit

open class ContentScrollView<ContentView: UIView>: UIScrollView {

  lazy private var contentViewEdgeConstraints: [NSLayoutConstraint] = [
    contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
    trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    contentView.topAnchor.constraint(equalTo: topAnchor),
    bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
  ]

  lazy private var contentViewDimensionConstraint: NSLayoutConstraint = contentViewDimensionConstraint(for: axis)

  open var axis: NSLayoutConstraint.Axis {
    didSet {
      reloadContentViewDimensionConstraint()
    }
  }

  public let contentView: ContentView

  public init(frame: CGRect = .zero, axis: NSLayoutConstraint.Axis, contentView: ContentView) {
    self.axis = axis
    self.contentView = contentView
    super.init(frame: frame)
    commonInit()
  }

  public override init(frame: CGRect = .zero) {
    axis = .horizontal
    contentView = .init()
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    axis = .horizontal
    contentView = .init()
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentView)

    NSLayoutConstraint.activate(contentViewEdgeConstraints)
    contentViewDimensionConstraint.isActive = true
  }

  private func contentViewDimensionConstraint(for axis: NSLayoutConstraint.Axis) -> NSLayoutConstraint {
    switch axis {
    case .horizontal:
      return contentView.widthAnchor.constraint(equalTo: widthAnchor)
    case .vertical:
      return contentView.heightAnchor.constraint(equalTo: heightAnchor)
    @unknown default:
      return contentView.widthAnchor.constraint(equalTo: widthAnchor)
    }
  }

  func reloadContentViewDimensionConstraint() {
    contentViewDimensionConstraint.isActive = false
    contentViewDimensionConstraint = contentViewDimensionConstraint(for: axis)
    contentViewDimensionConstraint.isActive = true
  }
}

#endif
