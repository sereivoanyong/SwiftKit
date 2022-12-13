//
//  UserDefaults.swift
//
//  Created by Sereivoan Yong on 1/23/20.
//

#if canImport(Foundation)
import Foundation

extension UserDefaults {

  public var appleLanguages: [String] {
    get { return object(forKey: "AppleLanguages") as? [String] ?? [] }
    set { set(newValue, forKey: "AppleLanguages") }
  }
}
#endif
