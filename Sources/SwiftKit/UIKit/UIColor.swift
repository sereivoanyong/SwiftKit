//
//  UIColor.swift
//
//  Created by Sereivoan Yong on 11/14/17.
//

#if canImport(UIKit)
import UIKit

extension UIColor {

  // MARK: Components

  /// The grayscale components of the color.
  ///
  /// If the color is in a compatible color space, it converts into grayscale format and its returned to your application. If the color isn’t in a compatible color space, the parameters don’t change.
  public var grayscaleComponents: (white: CGFloat, alpha: CGFloat)? {
    var components: (white: CGFloat, alpha: CGFloat) = (0, 0)
    if getWhite(&components.white, alpha: &components.alpha) {
      return components
    }
    return nil
  }

  /// The components that form the color in the HSB color space.
  ///
  /// If the color is in a compatible color space, it converts into the HSB color space, and its components return to your application. If the color isn’t in a compatible color space, the parameters don’t change.
  public var hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
    var components: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
    if getHue(&components.hue, saturation: &components.saturation, brightness: &components.brightness, alpha: &components.alpha) {
      return components
    }
    return nil
  }

  /// The components that form the color in the RGB color space.
  ///
  /// If the color is in a compatible color space, it converts into RGB format and its components return to your application. If the color isn’t in a compatible color space, the parameters don’t change.
  public var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
    if getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha) {
      return components
    }
    return nil
  }

  /// A Boolean value indicating whether the color is clear (alpha =0 0).
  public var isClear: Bool {
    return cgColor.alpha == 0
  }

  // MARK: Hex Support

  /// Creates a color object using the specified hexadecimal string.
  /// - Parameter hexString: A hexadecimal representation string #RRGGBB / #RRGGBBAA.
  public convenience init?(hexString: String) {
    var hexString = hexString
    if hexString.first == "#" {
      hexString.removeFirst()
    }
    var hexValue: UInt64 = 0
    guard Scanner(string: hexString).scanHexInt64(&hexValue) else {
      return nil
    }
    let red, green, blue, alpha: CGFloat
    switch hexString.count {
    case 3: // RGB
      let divisor = CGFloat(15)
      red   = CGFloat((hexValue & 0xF00) >> 8) / divisor
      green = CGFloat((hexValue & 0x0F0) >> 4) / divisor
      blue  = CGFloat( hexValue & 0x00F      ) / divisor
      alpha = 1
    case 4: // RGBA
      let divisor = CGFloat(15)
      red   = CGFloat((hexValue & 0xF000) >> 12) / divisor
      green = CGFloat((hexValue & 0x0F00) >>  8) / divisor
      blue  = CGFloat((hexValue & 0x00F0) >>  4) / divisor
      alpha = CGFloat( hexValue & 0x000F       ) / divisor
    case 6: // RRGGBB
      let divisor = CGFloat(255)
      red   = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
      green = CGFloat((hexValue & 0x00FF00) >>  8) / divisor
      blue  = CGFloat( hexValue & 0x0000FF       ) / divisor
      alpha = 1
    case 8: // RRGGBBAA
      let divisor = CGFloat(255)
      red   = CGFloat((hexValue & 0xFF000000) >> 24) / divisor
      green = CGFloat((hexValue & 0x00FF0000) >> 16) / divisor
      blue  = CGFloat((hexValue & 0x0000FF00) >>  8) / divisor
      alpha = CGFloat( hexValue & 0x000000FF       ) / divisor
    default:
      return nil
    }
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  /// The hexadecimal string.
  public var hexString: String? {
    guard let (red, green, blue, alpha) = rgbaDecimalComponents else {
      return nil
    }
    if alpha < 1 {
      return String(format: "#%02X%02X%02X%02X", red, green, blue, UInt8(alpha * 255))
    }
    return String(format: "#%02X%02X%02X", red, green, blue)
  }

  // MARK: Decimal (0-255) Support

  /// Creates a color object using the specified RGB decimal components (0-255) and opacity (0.0-1.0). `UInt8` is preferred.
  public static func decimal<T: BinaryInteger>(red: T, green: T, blue: T, alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
  }

  /// The decimal components (0-255) and opacity (0.0-1.0) that form the color in the RGB color space.
  ///
  /// If the color is in a compatible color space, it converts into RGB format and its components return to your application. If the color isn’t in a compatible color space, the parameters don’t change.
  public var rgbaDecimalComponents: (red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat)? {
    guard let (red, green, blue, alpha) = rgbaComponents else {
      return nil
    }
    return (UInt8(red * 255), UInt8(green * 255), UInt8(blue * 255), alpha)
  }

  public func rgbaInterpolated(to: UIColor, fraction: CGFloat) -> UIColor? {
    guard let from = rgbaComponents, let to = to.rgbaComponents else {
      return nil
    }
    let fraction = min(1, max(0, fraction))
    let red = from.red + (to.red - from.red) * fraction
    let green = from.green + (to.green - from.green) * fraction
    let blue = from.blue + (to.blue - from.blue) * fraction
    let alpha = from.alpha + (to.alpha - from.alpha) * fraction
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  public func opaque(on fillColor: UIColor) -> UIColor? {
    guard let source = rgbaComponents, source.alpha < 1 else {
      return self
    }
    guard let target = fillColor.rgbaComponents, target.alpha == 1 else {
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

  @available(iOS 13.0, *)
  public func dynamicReversed() -> UIColor {
    let anyColor = resolvedColor(with: UITraitCollection(userInterfaceStyle: .unspecified))
    let darkColor = resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    return UIColor { traitCollection in
      return traitCollection.userInterfaceStyle != .dark ? darkColor : anyColor
    }
  }

  /// Returns a random color.
  public static func random(alpha: CGFloat = 1) -> UIColor {
    return decimal(red: UInt8.random(), green: .random(), blue: .random(), alpha: alpha)
  }
}
#endif
