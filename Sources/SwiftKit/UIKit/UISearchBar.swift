//
//  UISearchBar.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UISearchBar {

  public var searchBarTextField: UITextField? {
    return valueIfResponds(forKey: "_searchBarTextField") as? UITextField
  }

  public var cancelButtonText: String? {
    get { return valueIfResponds(forKey: "_cancelButtonText") as? String }
    set { performIfResponds(Selector(("_setCancelButtonText:")), with: newValue) }
  }

  public var cancelButton: UIButton? {
    return performIfResponds(Selector(("cancelButton")))?.takeUnretainedValue() as? UIButton
  }
}
