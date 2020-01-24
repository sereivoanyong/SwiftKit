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
}

// Default system colors taken from https://developer.apple.com/design/resources/

extension UIColor {
  
  // Tinting
  
  public static var systemExtraLightGrayTint: UIColor {
    return UIColor(red: 10, green: 10, blue: 120, alpha: 0.05)
  }
  
  public static var systemLightGrayTint: UIColor {
    return UIColor(red: 25, green: 25, blue: 100, alpha: 0.07)
  }
  
  public static var systemLightMidGrayTint: UIColor {
    return UIColor(red: 25, green: 25, blue: 100, alpha: 0.18)
  }
  
  public static var systemMidGrayTint: UIColor {
    return UIColor(red: 0, green: 0, blue: 25, alpha: 0.22)
  }
  
  public static var systemGrayTint: UIColor {
    return UIColor(red: 4, green: 4, blue: 15, alpha: 0.45)
  }
}
#endif
