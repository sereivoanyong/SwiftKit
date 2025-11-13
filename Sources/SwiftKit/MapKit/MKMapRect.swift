//
//  MKMapRect.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 11/13/25.
//

#if canImport(MapKit)

import MapKit

extension MKMapRect {

  public init(center: CLLocationCoordinate2D, zoomLevel: Double, viewSize: CGSize) {
    let mercatorPerPoint = pow(2.0, 20.0 - zoomLevel)
    let width = mercatorPerPoint * viewSize.width
    let height = mercatorPerPoint * viewSize.height
    let center = MKMapPoint(center)
    self.init(x: center.x - width/2, y: center.y - height/2, width: width, height: height)
  }
}

#endif
