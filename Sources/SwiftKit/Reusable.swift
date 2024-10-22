//
//  Reusable.swift
//
//  Created by Sereivoan Yong on 4/13/21.
//

import UIKit

public typealias ReusableView = Reusable & UIView

public protocol Reusable: AnyObject {

  static var reuseIdentifier: String { get }

  func prepareForReuse()
}

extension Reusable {

  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionReusableView: Reusable {
}

extension UITableViewCell: Reusable {
}

extension UITableViewHeaderFooterView: Reusable {
}
