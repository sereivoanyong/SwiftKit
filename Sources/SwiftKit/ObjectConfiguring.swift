//
//  ObjectConfiguring.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/24/25.
//

public protocol ObjectConfiguring<Object>: AnyObject {

  associatedtype Object

  var object: Object! { get set }

  func configure(_ object: Object)
}
