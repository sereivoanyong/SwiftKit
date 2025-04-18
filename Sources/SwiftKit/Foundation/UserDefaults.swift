//
//  UserDefaults.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 4/18/25.
//

import Foundation

extension UserDefaults {

  public subscript(key: String) -> URL? {
    @inlinable get { return url(forKey: key) }
    @inlinable set { set(newValue, forKey: key) }
  }
}
