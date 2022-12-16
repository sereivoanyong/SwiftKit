//
//  FixedWidthInteger.swift
//
//  Created by Sereivoan Yong on 12/15/22.
//

extension FixedWidthInteger {

  /// Returns a random value within the range of minimum representable value and maximum representable value.
  public static func random() -> Self {
    return random(in: min...max)
  }
}
