//
//  UISearchBar.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(UIKit)
import UIKit

extension UISearchBar {
  
  @available(iOS 7.0, *)
  final public var searchBarTextField: UITextField? {
    return valueIfResponds(forKey: "_searchBarTextField") as? UITextField
  }
  
  final public var cancelButtonText: String? {
    get { return valueIfResponds(forKey: "_cancelButtonText") as? String }
    set { performIfResponds(Selector(("_setCancelButtonText:")), with: newValue) }
  }
}
#endif
