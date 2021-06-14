//
//  NibLoadable.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

public typealias NibReusable = NibLoadable & Reusable

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

  public static func loadFromNib(owner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil) -> Self where Self: UIView {
    return nib.instantiate(withOwner: owner, options: options)[0] as! Self
  }
}
#endif
