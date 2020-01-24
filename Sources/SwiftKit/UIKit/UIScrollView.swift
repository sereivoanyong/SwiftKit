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
}
#endif
