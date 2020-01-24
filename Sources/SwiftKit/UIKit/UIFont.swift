//
//  UIFont.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIFont {
  
  final public func lineHeight(numberOfLines: Int) -> CGFloat {
    return lineHeight * CGFloat(numberOfLines)
  }
  
  final public func lineHeight(numberOfLines: Int, lineSpacing: CGFloat) -> CGFloat {
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
  
  public func data() -> Data? {
    return CTFontCopyTable(CTFontCreateWithName(fontName as CFString, pointSize, nil), CTFontTableTag(kCTFontTableCFF), []) as Data?
  }
}
#endif
