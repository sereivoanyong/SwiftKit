//
//  Menu.swift
//
//  Created by Sereivoan Yong on 11/10/23.
//

import UIKit

extension Menu {

  /// Constants for identifying an app’s standard menus.
  ///
  /// Use these constants to identify `Menu` objects containing standard configurations.
  /// When creating a custom menu identifier, provide a reverse domain name string value, such as `Menu.Identifier("com.example.apple-samplecode.MenubarSample.reloadMenu")`.
  public struct Identifier: Hashable, RawRepresentable {

    public let rawValue: String

    public init(_ rawValue: String) {
      self.rawValue = rawValue
    }

    public init(rawValue: String) {
      self.rawValue = rawValue
    }
  }

  /// Options for configuring a menu’s appearance.
  public struct Options: OptionSet {

    public let rawValue: UInt

    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }

    /// Show children inline in parent, instead of hierarchically
    public static var displayInline: Options {
      Options(rawValue: 1 << 0)
    }

    /// Indicates whether the menu should be rendered with a destructive appearance in its parent
    public static var destructive: Options {
      Options(rawValue: 1 << 1)
    }
  }
}

/// A container for grouping related menu elements in an app menu or contextual menu.
///
/// Create `Menu` objects and use them to construct the menus and submenus your app displays. You provide menus for your app when it runs on macOS. You also use menus to display contextual actions in response to specific interactions with one of your views. Every menu has a title, an optional image, and an optional set of child elements. When the user selects an element from the menu, the system executes the code that you provide.
open class Menu: MenuElement {

  /// The unique identifier for the current menu.
  public let identifier: Identifier

  /// The configuration options for the current menu.
  public let options: Options

  /// The contents of the menu.
  public let children: [MenuElement]

  /// The element(s) in the menu and sub-menus that have an "on" menu item state.
  open var selectedElements: [MenuElement] {
    var selectedElements: [Action] = []
    for child in children {
      if let child = child as? Action, child.state == .on {
        selectedElements.append(child)
      }
    }
    return selectedElements
  }

  public init(
    title: String? = nil,
    subtitle: String? = nil,
    image: UIImage? = nil,
    identifier: Identifier? = nil,
    options: Options = [],
    children: [MenuElement] = []
  ) {
    self.identifier = identifier ?? Identifier(UUID().uuidString)
    self.options = options
    self.children = children
    super.init(title: title, subtitle: subtitle, image: image)
//    UIMenu
  }
}
