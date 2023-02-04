//
//  FloatingPoint.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Darwin)
import Darwin

extension FloatingPoint {

  @inlinable
  public var ceiled: Self {
    return Darwin.ceil(self)
  }

  @inlinable
  public var floored: Self {
    return Darwin.floor(self)
  }

  @inlinable
  public var rounded: Self {
    return Darwin.round(self)
  }

  @inlinable
  public mutating func ceil() {
    self = Darwin.ceil(self)
  }

  @inlinable
  public mutating func floor() {
    self = Darwin.floor(self)
  }

  @inlinable
  public mutating func round() {
    self = Darwin.round(self)
  }
}
#endif
