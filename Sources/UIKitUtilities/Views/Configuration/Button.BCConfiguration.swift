//
//  Button.BCConfiguration.swift
//
//  Created by Sereivoan Yong on 11/7/23.
//

import UIKit

@available(iOS 13.0, *)
extension Button.BCConfiguration {

  public enum Style: Int, CaseIterable {

    /// A style with a transparent background.
    case plain = 0

    /// A style with a gray background.
    case gray = 1

    /// A style with a tinted background color.
    case tinted = 2

    /// A style with a background filled with the button’s tint color.
    case filled = 3
  }

  /// A predefined size for button elements.
  ///
  /// You can use this enumeration to choose a predefined size for elements in a button. The value you choose for button size can be effectively overridden by explicitly assigning values for configuration elements like padding, corner style, or title and subtitle font sizes.
  public enum Size: Int, CaseIterable {

    /// Displays button elements at the smallest size.
    case mini = 0

    /// Displays button elements at a small size.
    case small = 1

    /// Displays button elements at a standard size.
    case medium = 2

    /// Displays button elements at a large size.
    case large = 3
  }

  /// Settings that determine the appearance of the background corner radius.
  ///
  /// Use this property to control how the button uses the cornerRadius property of the button’s background.
  public enum CornerStyle: Int, CaseIterable {

    /// A style that uses the background corner radius without modification.
    case fixed = 0

    /// A style that adjusts the background corner radius for dynamic type.
    case dynamic = 1

    /// A style that ignores the background corner radius and uses a small system-defined corner radius.
    case small = 2

    /// A style that ignores the background corner radius and uses a medium system-defined corner radius.
    case medium = 3

    /// A style that ignores the background corner radius and uses a large system-defined corner radius.
    case large = 4

    /// A style that ignores the background corner radius and uses a corner radius that generates a capsule.
    case capsule = 5
  }
}

@available(iOS 13.0, *)
extension Button {

  public struct BCConfiguration: Hashable {

    public init(style: Style) {
      self.style = style
    }

    public let style: Style

    public var background: BCBackgroundConfiguration = .init(cornerRadius: 5.95)

    public var cornerStyle: CornerStyle = .dynamic

    public var size: Size = .medium {
      didSet {
        switch size {
        case .mini:
          background.cornerRadius = 14
          contentInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
        case .small:
          background.cornerRadius = 14
          contentInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
        case .medium:
          background.cornerRadius = 5.95
          contentInsets = .init(top: 7, leading: 12, bottom: 7, trailing: 12)
        case .large:
          background.cornerRadius = 8.75
          contentInsets = .init(top: 15, leading: 20, bottom: 15, trailing: 20)
        }
      }
    }

    public var contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12)

    /// The edge against which the button places the image.
    public var imagePlacement: NSDirectionalRectEdge = .leading

    /// The distance between the button’s image and text.
    public var imagePadding: CGFloat = 0
  }
}

@available(iOS 15.0, *)
extension UIButton.Configuration {

  init(_ bcConfiguration: Button.BCConfiguration) {
    switch bcConfiguration.style {
    case .plain:
      self = .plain()
    case .gray:
      self = .gray()
    case .tinted:
      self = .tinted()
    case .filled:
      self = .filled()
    }
    switch bcConfiguration.size {
    case .mini:
      buttonSize = .mini
    case .small:
      buttonSize = .small
    case .medium:
      buttonSize = .medium
    case .large:
      buttonSize = .large
    }
    switch bcConfiguration.cornerStyle {
    case .fixed:
      cornerStyle = .fixed
    case .dynamic:
      cornerStyle = .dynamic
    case .small:
      cornerStyle = .small
    case .medium:
      cornerStyle = .medium
    case .large:
      cornerStyle = .large
    case .capsule:
      cornerStyle = .capsule
    }
    imagePlacement = bcConfiguration.imagePlacement
    imagePadding = bcConfiguration.imagePadding
  }
}
