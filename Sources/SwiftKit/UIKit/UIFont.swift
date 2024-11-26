//
//  UIFont.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UIFont {

  public var weight: Weight? {
    return fontDescriptor.weight
  }

  public func withWeight(_ weight: Weight) -> UIFont {
    return UIFont(descriptor: fontDescriptor.withWeight(weight), size: 0)
  }

  public func lineHeight(numberOfLines: Int) -> CGFloat {
    return lineHeight * CGFloat(numberOfLines)
  }

  public func lineHeight(numberOfLines: Int, lineSpacing: CGFloat) -> CGFloat {
    return lineHeight(numberOfLines: numberOfLines) + lineSpacing * CGFloat(numberOfLines - 1)
  }

  public convenience init?(data: Data, size: CGFloat) throws {
    guard let dataProvider = CGDataProvider(data: data as CFData), let font = CGFont(dataProvider) else {
      return nil
    }
    var error: Unmanaged<CFError>?
    if CTFontManagerRegisterGraphicsFont(font, &error) {
      self.init(name: font.postScriptName! as String, size: size)
    } else {
      throw error!.takeUnretainedValue() as Error
    }
  }

  public func addingFallback(to fallbackFont: UIFont) -> UIFont {
    return addingFallbackFont(name: fallbackFont.fontName)
  }

  public func addingFallbackFont(name: String) -> UIFont {
    return UIFont(descriptor: fontDescriptor.addingAttributes([.cascadeList: [UIFontDescriptor(fontAttributes: [.name: name])]]), size: 0)
  }

  public func data() -> Data? {
    return CTFontCopyTable(CTFontCreateWithName(fontName as CFString, pointSize, nil), CTFontTableTag(kCTFontTableCFF), []) as Data?
  }
}

// https://gist.github.com/sebjvidal/013fc653dfbda4290ac35bbbad8dcfb1
extension UIFont.TextStyle {

  public static var emphasizedLargeTitle: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedTitle0")
  }

  public static var emphasizedTitle1: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedTitle1")
  }

  public static var emphasizedTitle2: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedTitle2")
  }

  public static var emphasizedTitle3: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedTitle3")
  }

  public static var emphasizedHeadline: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedHeadline")
  }

  public static var emphasizedBody: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedBody")
  }

  public static var emphasizedCallout: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedCallout")
  }

  public static var emphasizedSubheadline: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedSubhead")
  }

  public static var emphasizedFootnote: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedFootnote")
  }

  public static var emphasizedCaption1: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedCaption1")
  }

  public static var emphasizedCaption2: UIFont.TextStyle {
    return UIFont.TextStyle(rawValue: "UICTFontTextStyleEmphasizedCaption2")
  }
}
