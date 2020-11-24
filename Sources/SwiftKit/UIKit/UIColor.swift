//
//  UIColor.swift
//
//  Created by Sereivoan Yong on 11/14/17.
//

#if canImport(UIKit)
import UIKit

extension UIColor {
  
  public static var random: UIColor {
    return integer(red: .random(in: 0...255), green: .random(in: 0...255), blue: .random(in: 0...255), alpha: 100)
  }
  
  public var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    switch cgColor.numberOfComponents {
    case 2:
      let c = cgColor.components!
      return (c[0], c[0], c[0], c[1])
    case 4:
      let c = cgColor.components!
      return (c[0], c[1], c[2], c[3])
    default:
      return nil
    }
  }
  
  public var integerComponent: (red: Int, green: Int, blue: Int, alpha: Int)? {
    guard let (red, green, blue, alpha) = components else {
      return nil
    }
    return (Int(red * 255), Int(green * 255), Int(blue * 255), Int(alpha * 100))
  }
  
  final public func opaque(on opaqueColor: UIColor) -> UIColor? {
    guard let source = components, source.alpha < 1 else {
      return self
    }
    guard let target = opaqueColor.components, target.alpha == 1 else {
      return nil
    }
    let opaque: (CGFloat, CGFloat, CGFloat) -> CGFloat = { from, to, alpha in
      return from * alpha + to * (1 - alpha)
    }
    return UIColor(
      red: opaque(source.red, target.red, source.alpha),
      green: opaque(source.green, target.green, source.alpha),
      blue: opaque(source.blue, target.blue, source.alpha),
      alpha: 1
    )
  }
  
  /// Creates a color object using the specified opacity and RGB component values
  /// - Parameters:
  ///   - red: The red value of the color object, specified as a value from 0 to 255
  ///   - green: The green value of the color object, specified as a value from 0 to 255
  ///   - blue: The blue value of the color object, specified as a value from 0 to 255
  ///   - alpha: The opacity value of the color object, specified as a value from 0 to 100
  @inlinable public static func integer(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 100.0)
  }
  
  public static func interpolated(from fromColor: UIColor, to toColor: UIColor, fraction: CGFloat) -> UIColor {
    let f = min(1, max(0, fraction))
    let c1 = fromColor.components!
    let c2 = toColor.components!
    let r = c1.0 + (c2.0 - c1.0) * f
    let g = c1.1 + (c2.1 - c1.1) * f
    let b = c1.2 + (c2.2 - c1.2) * f
    let a = c1.3 + (c2.3 - c1.3) * f
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
  
  /**
   The shorthand three-digit hexadecimal representation of color.
   #RGB defines to the color #RRGGBB.
   
   - parameter hex3: Three-digit hexadecimal value.
   - parameter alpha: 0.0 - 1.0.
   */
  public convenience init(hex3: UInt16, alpha: CGFloat) {
    let divisor = CGFloat(15)
    let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
    let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
    let blue    = CGFloat( hex3 & 0x00F      ) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  /**
   The shorthand four-digit hexadecimal representation of color with alpha.
   #RGBA defines to the color #RRGGBBAA.
   
   - parameter hex4: Four-digit hexadecimal value.
   */
  public convenience init(hex4: UInt16) {
    let divisor = CGFloat(15)
    let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
    let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
    let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
    let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  /**
   The six-digit hexadecimal representation of color of the form #RRGGBB.
   
   - parameter hex6: Six-digit hexadecimal value.
   */
  public convenience init(hex6: UInt32, alpha: CGFloat) {
    let divisor = CGFloat(255)
    let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
    let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
    let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  /**
   The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.
   
   - parameter hex8: Eight-digit hexadecimal value.
   */
  public convenience init(hex8: UInt32) {
    let divisor = CGFloat(255)
    let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
    let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
    let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
    let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  /**
   The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.
   
   - parameter rgba: String value.
   */
  public convenience init?(hexString: String) {
    var hexString = hexString
    if hexString.hasPrefix("#") {
      hexString.removeFirst()
    }
    var hexValue: UInt32 = 0
    guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
      return nil
    }
    
    switch hexString.count {
    case 3:
      self.init(hex3: UInt16(hexValue), alpha: 1)
    case 4:
      self.init(hex4: UInt16(hexValue))
    case 6:
      self.init(hex6: hexValue, alpha: 1)
    case 8:
      self.init(hex8: hexValue)
    default:
      return nil
    }
  }
  
  /**
   Hex string of a UIColor instance.
   
   - parameter includeAlpha: Whether the alpha should be included.
   */
  public func hexString(_ includesAlpha: Bool = true) -> String?  {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    switch cgColor.numberOfComponents {
    case 2:
      var white: CGFloat = 0
      getWhite(&white, alpha: &alpha)
      red = white
      green = white
      blue = white
    case 4:
      getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    default:
      return nil
    }
    
    if includesAlpha {
      return String(format: "#%02X%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255), Int(alpha * 255))
    } else {
      return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
  }
  
  // MARK: iOS 13 Color Compatibility
  // https://github.com/noahsark769/ColorCompatibility/blob/master/ColorCompatibility.swift
  
  /* Shades of gray. systemGray is the base gray color.
   */
  
  /// Returns the base gray color.
  ///
  /// This color represents the standard system grey. It adapts to the current environment.
  @inlinable public static func systemGray() -> UIColor {
    return systemGray
  }
  
  /* The numbered variations, systemGray2 through systemGray6, are grays which increasingly
   * trend away from systemGray and in the direction of systemBackgroundColor.
   *
   * In UIUserInterfaceStyleLight: systemGray1 is slightly lighter than systemGray.
   *                               systemGray2 is lighter than that, and so on.
   * In UIUserInterfaceStyleDark:  systemGray1 is slightly darker than systemGray.
   *                               systemGray2 is darker than that, and so on.
   */
  
  /// Returns second-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray()`. In dark environments, this grey is slightly darker than `systemGray()`.
  @inlinable public static func systemGray2() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray2
    }
    return UIColor(red: 0.6823529411764706, green: 0.6823529411764706, blue: 0.6980392156862745, alpha: 1.0)
  }
  
  /// Returns a third-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray2()`. In dark environments, this grey is slightly darker than `systemGray2()`.
  @inlinable public static func systemGray3() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray3
    }
    return UIColor(red: 0.7803921568627451, green: 0.7803921568627451, blue: 0.8, alpha: 1.0)
  }
  
  /// Returns a fourth-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray3()`. In dark environments, this grey is slightly darker than `systemGray3()`.
  @inlinable public static func systemGray4() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray4
    }
    return UIColor(red: 0.8196078431372549, green: 0.8196078431372549, blue: 0.8392156862745098, alpha: 1.0)
  }
  
  /// Returns a fifth-level shade of grey.
  ///
  /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray4()`. In dark environments, this grey is slightly darker than `systemGray4()`.
  @inlinable public static func systemGray5() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray5
    }
    return UIColor(red: 0.8980392156862745, green: 0.8980392156862745, blue: 0.9176470588235294, alpha: 1.0)
  }
  
  /// Returns a sixth-level shade of grey.
  ///
  /// This color adapts to the current environment, and is close in color to `systemBackground()`. In light environments, this grey is slightly lighter than `systemGray5()`. In dark environments, this grey is slightly darker than `systemGray5()`.
  @inlinable public static func systemGray6() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGray6
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }
  
  /* Foreground colors for static text and related elements.
   */
  
  /// Returns the color for text labels that contain primary content.
  @inlinable public static func label() -> UIColor {
    if #available(iOS 13.0, *) {
      return label
    }
    return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
  }
  
  /// Returns the color for text labels that contain secondary content.
  @inlinable public static func secondaryLabel() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondaryLabel
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.6)
  }
  
  /// Returns the color for text labels that contain tertiary content.
  @inlinable public static func tertiaryLabel() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiaryLabel
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.3)
  }
  
  /// Returns the color for text labels that contain quaternary content.
  @inlinable public static func quaternaryLabel() -> UIColor {
    if #available(iOS 13.0, *) {
      return quaternaryLabel
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.18)
  }
  
  /* Foreground color for standard system links.
   */
  
  /// Returns the color for links.
  @inlinable public static func link() -> UIColor {
    if #available(iOS 13.0, *) {
      return link
    }
    return UIColor(red: 0.0, green: 0.47843137254901963, blue: 1.0, alpha: 1.0)
  }
  
  /* Foreground color for placeholder text in controls or text fields or text views.
   */
  
  /// Returns the color for placeholder text in controls or text views.
  @inlinable public static func placeholderText() -> UIColor {
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
  @inlinable public static func separator() -> UIColor {
    if #available(iOS 13.0, *) {
      return separator
    }
    return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.29)
  }
  
  /// Returns the color for borders or divider lines that hides any underlying content.
  ///
  /// This color is always opaque. It adapts to the underlying trait environment.
  @inlinable public static func opaqueSeparator() -> UIColor {
    if #available(iOS 13.0, *) {
      return opaqueSeparator
    }
    return UIColor(red: 0.7764705882352941, green: 0.7764705882352941, blue: 0.7843137254901961, alpha: 1.0)
  }
  
  /* We provide two design systems (also known as "stacks") for structuring an iOS app's backgrounds.
   *
   * Each stack has three "levels" of background colors. The first color is intended to be the
   * main background, farthest back. Secondary and tertiary colors are layered on top
   * of the main background, when appropriate.
   *
   * Inside of a discrete piece of UI, choose a stack, then use colors from that stack.
   * We do not recommend mixing and matching background colors between stacks.
   * The foreground colors above are designed to work in both stacks.
   *
   * 1. systemBackground
   *    Use this stack for views with standard table views, and designs which have a white
   *    primary background in light mode.
   */
  
  /// Returns he color for the main background of your interface.
  @inlinable public static func systemBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemBackground
    }
    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }
  
  /// Returns the color for content layered on top of the main background.
  @inlinable public static func secondarySystemBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondarySystemBackground
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }
  
  /// Returns the color for content layered on top of secondary backgrounds.
  @inlinable public static func tertiarySystemBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiarySystemBackground
    }
    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }
  
  /* 2. systemGroupedBackground
   *    Use this stack for views with grouped content, such as grouped tables and
   *    platter-based designs. These are like grouped table views, but you may use these
   *    colors in places where a table view wouldn't make sense.
   */
  
  /// Returns the color for the main background of your grouped interface.
  @inlinable public static func systemGroupedBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemGroupedBackground
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }
  
  /// Returns the color for content layered on top of the main background of your grouped interface.
  @inlinable public static func secondarySystemGroupedBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondarySystemGroupedBackground
    }
    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }
  
  /// Returns the color for content layered on top of secondary backgrounds of your grouped interface.
  @inlinable public static func tertiarySystemGroupedBackground() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiarySystemGroupedBackground
    }
    return UIColor(red: 0.9490196078431372, green: 0.9490196078431372, blue: 0.9686274509803922, alpha: 1.0)
  }
  
  /* Fill colors for UI elements.
   * These are meant to be used over the background colors, since their alpha component is less than 1.
   *
   * systemFillColor is appropriate for filling thin and small shapes.
   * Example: The track of a slider.
   */
  
  /// Returns an overlay fill color for thin and small shapes
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill thin or small shapes, such as the track of a slider.
  @inlinable public static func systemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return systemFill
    }
    return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.2)
  }
  
  /* secondarySystemFillColor is appropriate for filling medium-size shapes.
   * Example: The background of a switch.
   */
  
  /// Returns an overlay fill color for medium-size shapes.
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill medium-size shapes, such as the background of a switch.
  @inlinable public static func secondarySystemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return secondarySystemFill
    }
    return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.16)
  }
  
  /* tertiarySystemFillColor is appropriate for filling large shapes.
   * Examples: Input fields, search bars, buttons.
   */
  
  /// Returns an overlay fill color for large shapes.
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill large shapes, such as input fields, search bars, or buttons.
  @inlinable public static func tertiarySystemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return tertiarySystemFill
    }
    return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.12)
  }
  
  /* quaternarySystemFillColor is appropriate for filling large areas containing complex content.
   * Example: Expanded table cells.
   */
  
  /// Returns an overlay fill color for large areas that contain complex content.
  ///
  /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
  ///
  /// Use this color to fill large areas that contain complex content, such as an expanded table cell
  @inlinable public static func quaternarySystemFill() -> UIColor {
    if #available(iOS 13.0, *) {
      return quaternarySystemFill
    }
    return UIColor(red: 0.4549019607843137, green: 0.4549019607843137, blue: 0.5019607843137255, alpha: 0.08)
  }
}
#endif
