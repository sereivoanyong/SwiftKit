//
//  Reusable.swift
//
//  Created by Sereivoan Yong on 4/13/21.
//

public protocol Reusable: AnyObject {

  static var reuseIdentifier: String { get }
}

extension Reusable {

  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}
