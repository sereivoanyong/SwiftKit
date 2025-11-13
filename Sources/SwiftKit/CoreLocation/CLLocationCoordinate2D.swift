//
//  CLLocationCoordinate2D.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/13/25.
//

#if canImport(CoreLocation)

import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}

extension CLLocationCoordinate2D: @retroactive Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }
}

#endif
