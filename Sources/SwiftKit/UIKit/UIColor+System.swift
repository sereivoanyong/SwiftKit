//
//  UIColor+System.swift
//
//  Created by Sereivoan Yong on 12/16/22.
//

import UIKit.UIColor

// MARK: iOS 13 Color Compatibility
// https://github.com/noahsark769/ColorCompatibility/blob/master/ColorCompatibility.swift

extension UIColor {

  /// Returns the base gray color.
  ///
  /// This color represents the standard system grey. It adapts to the current environment.
  @inlinable
  public static func systemGray() -> UIColor {
    return systemGray
  }

  /// Returns second-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray()`. In dark environments, this grey is slightly darker than `systemGray()`.
  @inlinable
  public static func systemGray2() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray2
    }
    return UIColor(red: 0.6823529411764706, green: 0.6823529411764706, blue: 0.6980392156862745, alpha: 1.0)
  }

  /// Returns a third-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray2()`. In dark environments, this grey is slightly darker than `systemGray2()`.
  @inlinable
  public static func systemGray3() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray3
    }
    return UIColor(red: 0.7803921568627451, green: 0.7803921568627451, blue: 0.8, alpha: 1.0)
  }

  /// Returns a fourth-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray3()`. In dark environments, this grey is slightly darker than `systemGray3()`.
  @inlinable
  public static func systemGray4() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray4
    }
    return UIColor(red: 0.8196078431372549, green: 0.8196078431372549, blue: 0.8392156862745098, alpha: 1.0)
  }

  /// Returns a fifth-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray4()`. In dark environments, this grey is slightly darker than `systemGray4()`.
  @inlinable
  public static func systemGray5() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray5
    }
    return UIColor(red: 0.8980392156862745, green: 0.8980392156862745, blue: 0.9176470588235294, alpha: 1.0)
  }

  /// Returns a sixth-level shade of grey.
  ///
  /// This color adapts to the current environment, and is close in color to `systemBackground()`. In light environments, this grey is slightly lighter than `systemGray5()`. In dark environments, this grey is slightly darker than `systemGray5()`.
  @inlinable
  public static func systemGray6() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray6
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }

  /// Returns the color for text labels that contain primary content.
  @inlinable
  public static func label() -> UIColor {
    if #available(iOS 13.0, *) {
      return label
    }
    return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
  }

  /// Returns the color for text labels that contain secondary content.
  @inlinable
  public static func secondaryLabel() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondaryLabel
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.6)
  }

  /// Returns the color for text labels that contain tertiary content.
  @inlinable
  public static func tertiaryLabel() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiaryLabel
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.3)
  }

  /// Returns the color for text labels that contain quaternary content.
  @inlinable
  public static func quaternaryLabel() -> UIColor {
    if #available(iOS 13.0, *) {
      return quaternaryLabel
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.18)
  }

  /// Returns the color for links.
  @inlinable
  public static func link() -> UIColor {
    if #available(iOS 13.0, *) {
      return link
    }
    return UIColor(red: 0.0, green: 0.47843137254901963, blue: 1.0, alpha: 1.0)
  }

  /// Returns the color for placeholder text in controls or text views.
  @inlinable
  public static func placeholderText() -> UIColor {
    if #available(iOS 13.0, *) {
      return placeholderText
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.3)
  }

  /* Foreground colors for separators (thin border or divider lines).
   * `separatorColor` may be partially transparent, so it can go on top of any content.
   * `opaqueSeparatorColor` is intended to look similar, but is guaranteed to be opaque, so it will
   * completely cover anything behind it. Depending on the situation, you may need one or the other.
   */

  /// Returns the color for thin borders or divider lines that allows some underlying content to be visible.
  ///
  /// This color may be partially transparent to allow the underlying content to show through. It adapts to the underlying trait environment.
  @inlinable
  public static func separator() -> UIColor {
    if #available(iOS 13.0, *) {
      return separator
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.29)
  }

  /// Returns the color for borders or divider lines that hides any underlying content.
  ///
  /// This color is always opaque. It adapts to the underlying trait environment.
  @inlinable
  public static func opaqueSeparator() -> UIColor {
    if #available(iOS 13.0, *) {
      return opaqueSeparator
    }
    return UIColor(red: 0.7764705882352941, green: 0.7764705882352941, blue: 0.7843137254901961, alpha: 1.0)
  }

  /// Returns he color for the main background of your interface.
  ///
  /// Use this color for standard table views and designs that have a white primary background in a light environment.
  @inlinable
  public static func systemBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemBackground
    }
    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }

  /// Returns the color for content layered on top of the main background.
  ///
  /// Use this color for standard table views and designs that have a white primary background in a light environment.
  @inlinable
  public static func secondarySystemBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondarySystemBackground
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }

  /// Returns the color for content layered on top of secondary backgrounds.
  ///
  /// Use this color for standard table views and designs that have a white primary background in a light environment.
  @inlinable
  public static func tertiarySystemBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiarySystemBackground
    }
    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }

  /// Returns the color for the main background of your grouped interface.
  ///
  /// Use this color for grouped content, including table views and platter-based designs.
  @inlinable
  public static func systemGroupedBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGroupedBackground
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }

  /// Returns the color for content layered on top of the main background of your grouped interface.
  ///
  /// Use this color for grouped content, including table views and platter-based designs.
  @inlinable
  public static func secondarySystemGroupedBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondarySystemGroupedBackground
    }
    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }

  /// Returns the color for content layered on top of secondary backgrounds of your grouped interface.
  ///
  /// Use this color for grouped content, including table views and platter-based designs.
  @inlinable
  public static func tertiarySystemGroupedBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiarySystemGroupedBackground
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }

  /// Returns an overlay fill color for thin and small shapes
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill thin or small shapes, such as the track of a slider.
  @inlinable
  public static func systemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemFill
    }
    return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.2)
  }

  /// Returns an overlay fill color for medium-size shapes.
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill medium-size shapes, such as the background of a switch.
  @inlinable
  public static func secondarySystemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondarySystemFill
    }
    return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.16)
  }

  /// Returns an overlay fill color for large shapes.
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill large shapes, such as input fields, search bars, or buttons.
  @inlinable
  public static func tertiarySystemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiarySystemFill
    }
    return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.12)
  }

  /// Returns an overlay fill color for large areas that contain complex content.
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill large areas that contain complex content, such as an expanded table cell
  @inlinable
  public static func quaternarySystemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return quaternarySystemFill
    }
    return UIColor(red: 0.4549019607843137, green: 0.4549019607843137, blue: 0.5019607843137255, alpha: 0.08)
  }
}
