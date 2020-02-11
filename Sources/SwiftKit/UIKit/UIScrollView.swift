//
//  UIScrollView.swift
//
//  Created by Sereivoan Yong on 10/29/19.
//

#if canImport(UIKit)
import UIKit

extension UIScrollView {
  
  /// Returns a snapshot of an entire content of the scroll view
  final public func contentSnapshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
    let context = UIGraphicsGetCurrentContext()!
    let previousFrame = frame
    frame = CGRect(origin: frame.origin, size: contentSize)
    layer.render(in: context)
    frame = previousFrame
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
  @available(iOS 11.0, *)
  @inlinable final public func addArrangedSubviews(_ views: [UIView], spacing: CGFloat = 0, insets: UIEdgeInsets = .zero, axis: NSLayoutConstraint.Axis) {
    switch axis {
    case .horizontal:
      var lastRightAnchor = contentLayoutGuide.leftAnchor
      for (index, view) in views.enumerated() {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.pinVerticalAnchors(inside: contentLayoutGuide)
        view.leftAnchor.equalTo(lastRightAnchor, constant: index > 0 ? spacing : insets.left)
        lastRightAnchor = view.rightAnchor
      }
      contentLayoutGuide.rightAnchor.equalTo(views.last!.rightAnchor, constant: insets.right)
      contentLayoutGuide.heightAnchor.equalTo(frameLayoutGuide.heightAnchor)
      
    case .vertical:
      var lastBottomAnchor = contentLayoutGuide.topAnchor
      for (index, view) in views.enumerated() {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.pinHorizontalAnchors(inside: contentLayoutGuide)
        view.topAnchor.equalTo(lastBottomAnchor, constant: index > 0 ? spacing : insets.top)
        lastBottomAnchor = view.bottomAnchor
      }
      contentLayoutGuide.bottomAnchor.equalTo(views.last!.bottomAnchor, constant: insets.bottom)
      contentLayoutGuide.widthAnchor.equalTo(frameLayoutGuide.widthAnchor)
      
    @unknown default:
      fatalError()
    }
  }
  
  @available(iOS 11.0, *)
  final public func addContentView(_ contentView: UIView, insets: UIEdgeInsets = .zero, axis: NSLayoutConstraint.Axis) {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentView)
    
    var constraints: [NSLayoutConstraint] = [
      contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: insets.top),
      contentView.leftAnchor.constraint(equalTo: contentLayoutGuide.leftAnchor, constant: insets.left),
      contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: insets.bottom),
      contentLayoutGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: insets.right),
    ]
    switch axis {
    case .horizontal:
      constraints.append(contentLayoutGuide.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor))
    case .vertical:
      constraints.append(contentLayoutGuide.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor))
    @unknown default:
      fatalError()
    }
    NSLayoutConstraint.activate(constraints)
  }
}
#endif
