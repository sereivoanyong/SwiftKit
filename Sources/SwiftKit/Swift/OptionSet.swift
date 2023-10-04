//
//  OptionSet.swift
//
//  Created by Sereivoan Yong on 11/10/23.
//

import Foundation

extension OptionSet where RawValue: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue)
  }
}
