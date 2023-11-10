//
//  MenuElement.swift
//
//  Created by Sereivoan Yong on 11/10/23.
//

import UIKit

extension MenuElement {

  /// Constants that indicate the state of an action- or command-based menu element.
  public enum State: Int {

    case off = 0
    case on = 1
    case mixed = 2
  }

  /// Attributes that determine the style of the menu element.
  public struct Attributes: OptionSet {

    public let rawValue: UInt

    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }

    public static var disabled: Attributes {
      Attributes(rawValue: 1 << 0)
    }

    public static var destructive: Attributes {
      Attributes(rawValue: 1 << 1)
    }

    public static var hidden: Attributes {
      Attributes(rawValue: 1 << 2)
    }
  }
}

/// An object representing a menu, action, or command.
///
/// `MenuElement` defines the behavior shared by all menus, actions, and commands. You don’t create `MenuElement` objects directly. Instead, you create an appropriate object that inherits from this class, such as `Menu`, `Action`, or `Command`.
open class MenuElement: NSObject {

  /// The title of the menu element.
  open var title: String?

  /// The subtitle to display alongside the menu element’s title.
  ///
  /// Only the context menu system supports the display of a subtitle, and only when the app is running on iOS.
  open var subtitle: String?

  /// The image to display alongside the menu element’s title.
  ///
  /// Only the context menu system supports the display of an image, and only when the app is running in iOS.
  open var image: UIImage?

  init(title: String?, subtitle: String? = nil, image: UIImage? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
//    UIMenuElement
  }
}
