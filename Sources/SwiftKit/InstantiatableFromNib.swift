//
//  InstantiatableFromNib.swift
//
//  Created by Sereivoan Yong on 12/8/17.
//

#if canImport(UIKit)
import UIKit

public protocol InstantiatableFromNib: AnyObject {
  
  static var nibName: String { get }
}

extension InstantiatableFromNib {
  
  public static var nibName: String {
    return String(describing: self)
  }
}

extension InstantiatableFromNib where Self: UIViewController {
  
  public static func loadFromNib(in bundle: Bundle? = nil) -> Self {
    return Self.init(nibName: nibName, bundle: bundle)
  }
}

extension InstantiatableFromNib where Self: UIView {
  
  public static func nib(in bundle: Bundle? = nil) -> UINib {
    return UINib(nibName: nibName, bundle: bundle)
  }
  
  public static func loadFromNib(in bundle: Bundle? = nil, owner: Any? = nil) -> Self {
    return nib(in: bundle).instantiate(withOwner: owner, options: nil)[0] as! Self
  }
}
#endif
