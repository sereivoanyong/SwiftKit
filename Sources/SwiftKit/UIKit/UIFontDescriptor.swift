//
//  UIFontDescriptor.swift
//
//  Created by Sereivoan Yong on 11/24/20.
//

#if canImport(UIKit)
import UIKit

extension UIFontDescriptor {
  
  final public func withWeight(_ weight: UIFont.Weight) -> UIFontDescriptor {
    var traits = object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
    traits[.weight] = weight
    return addingAttributes([.traits: traits])
  }
}
#endif
