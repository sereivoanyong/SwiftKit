//
//  NibLoadable.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

import UIKit

public protocol NibLoadable: AnyObject {

  static var nibName: String { get }
  static var bundleForNib: Bundle? { get }
}

public protocol NibLoadableView: UIView, NibLoadable {

  static var instantiatingIndexInNib: Int { get }
}

private var cachedNibsKey: Void?

extension NibLoadable {

  public static var nibName: String {
    return String(describing: self)
  }

  public static var bundleForNib: Bundle? {
    return Bundle(for: self)
  }

  public static func nib() -> UINib {
    return UINib(nibName: nibName, bundle: bundleForNib)
  }

  public static func nib(associatedWith object: AnyObject) -> UINib {
    let nibName = nibName
    let associatedNibs = UINib.associatedNibs(with: object)
    if let associatedNib = associatedNibs?[nibName] {
      return associatedNib
    }
    let nib = nib()
    if var associatedNibs {
      associatedNibs[nibName] = nib
      setAssociatedValue(associatedNibs, forKey: &cachedNibsKey, with: object)
    } else {
      setAssociatedValue([nibName: nib], forKey: &cachedNibsKey, with: object)
    }
    return nib
  }

  public static func loadFromNib(owner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil, index: Int? = nil) -> Self where Self: UIView {
    let nib = nib()
    let index = index ?? (self as? NibLoadableView.Type)?.instantiatingIndexInNib ?? 0
    return nib.instantiate(withOwner: owner, options: options)[index] as! Self
  }
}

extension UINib {

  public static func associatedNibs(with object: AnyObject) -> [String: UINib]? {
    return associatedValue(forKey: &cachedNibsKey, with: object)
  }
}
