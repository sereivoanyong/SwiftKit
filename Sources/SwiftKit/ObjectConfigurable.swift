//
//  ObjectConfigurable.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

public protocol ObjectConfigurable {
  
  associatedtype Object
  
  func configure(_ object: Object)
}
