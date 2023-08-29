//
//  UIStoryboard.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

import UIKit

extension UIStoryboard {

  public static var main: UIStoryboard? {
    let bundle = Bundle.main
    if let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String {
      return UIStoryboard(name: name, bundle: bundle)
    }
    return nil
  }

  public func instantiate<ViewController>(_ viewControllerClass: ViewController.Type, identifier: String = String(describing: ViewController.self)) -> ViewController where ViewController: UIViewController {
    return unsafeDowncast(instantiateViewController(withIdentifier: identifier), to: ViewController.self)
  }
}
