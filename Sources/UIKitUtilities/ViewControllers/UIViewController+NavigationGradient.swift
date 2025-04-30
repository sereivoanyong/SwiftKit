//
//  UIViewController+NavigationGradient.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/29/25.
//

import UIKit
import SwiftKit

extension UIViewController {

  public static let navigationGradientOvershootHeight: CGFloat = 60

  public static var navigationGradientColor: UIColor = UIColor(white: 0, alpha: 0.18)

  private static var offsetObservationKey: Void?
  private var offsetObservation: NSKeyValueObservation? {
    get { return associatedObject(forKey: &Self.offsetObservationKey, with: self) }
    set { setAssociatedObject(newValue, forKey: &Self.offsetObservationKey, with: self) }
  }

  private static var navigationGradientViewKey: Void?
  public private(set) var navigationGradientView: GradientView! {
    get {
      if let navigationGradientView = associatedObject(forKey: &Self.navigationGradientViewKey, with: self) as GradientView? {
        return navigationGradientView
      }
      let navigationGradientView = GradientView(configuration: .init(
        colors: [Self.navigationGradientColor, Self.navigationGradientColor, .clear],
        locations: [.absolute(0), .custom({ frame in max(frame.height - Self.navigationGradientOvershootHeight, 0) / frame.height }), .absolute(1)],
        startPoint: CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint(x: 0.5, y: 1)
      ))
      setAssociatedObject(navigationGradientView, forKey: &Self.navigationGradientViewKey, with: self)
      view.addSubview(navigationGradientView)

      navigationGradientView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        navigationGradientView.topAnchor.constraint(equalTo: view.topAnchor),
        navigationGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: navigationGradientView.trailingAnchor),
        navigationGradientView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Self.navigationGradientOvershootHeight),
      ])
      return navigationGradientView
    }
    set { setAssociatedObject(newValue, forKey: &Self.navigationGradientViewKey, with: self) }
  }

  public func setContentScrollViewForNavigationGradient(_ scrollView: UIScrollView, maximumHeightProvider: @escaping () -> CGFloat) {
    offsetObservation = scrollView.observe(\.contentOffset) { [weak self] scrollView, _ in
      guard let self else { return }
      let offset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
      let maximumHeight = maximumHeightProvider()
      let alpha = min(max(offset / maximumHeight, 0), 1)
      navigationGradientView.alpha = 1 - alpha
    }
  }
}
