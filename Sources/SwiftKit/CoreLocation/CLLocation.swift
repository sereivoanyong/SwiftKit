//
//  CLLocation.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/6/25.
//

#if canImport(CoreLocation)

import CoreLocation

extension CLLocation {

  @inlinable
  public convenience init(coordinate: CLLocationCoordinate2D) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }

  @inlinable
  public func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
    return distance(from: CLLocation(coordinate: coordinate))
  }
}

#endif
