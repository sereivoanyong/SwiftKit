//
//  ObjectIdentifiable.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

public protocol ObjectIdentifiable {
  
  associatedtype ID: Hashable
  var id: ID { get }
}
