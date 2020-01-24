//
//  NSDictionary.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

#if canImport(Foundation)
import Foundation

extension NSDictionary {
  
  public convenience init?(resourceName: String, extension: String, in bundle: Bundle = .main) {
    if let path = bundle.path(forResource: resourceName, ofType: `extension`) {
      self.init(contentsOfFile: path)
    } else {
      return nil
    }
  }
}
#endif
