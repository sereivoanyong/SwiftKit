//
//  ObjectIdentifiable.swift
//
//  Created by Sereivoan Yong on 2/26/20.
//

public protocol ObjectIdentifiable {
  
  associatedtype ID: Hashable
  var id: ID { get }
}

public protocol HashableObjectIdentifiable: ObjectIdentifiable, Hashable {
  
}

extension HashableObjectIdentifiable {
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
