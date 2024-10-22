//
//  NibLoadable.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

import UIKit

public protocol NibLoadable: AnyObject {

  static var nibName: String { get }
  static var nibBundle: Bundle? { get }
}

extension NibLoadable {

  public static var nibName: String {
    return String(describing: self)
  }

  public static var nibBundle: Bundle? {
    return Bundle(for: self)
  }

  public static var nib: UINib {
    return UINib(nibName: nibName, bundle: nibBundle)
  }

  public static func loadFromNib(owner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil, index: Int = 0) -> Self where Self: UIView {
    return nib.instantiate(withOwner: owner, options: options)[index] as! Self
  }
}
