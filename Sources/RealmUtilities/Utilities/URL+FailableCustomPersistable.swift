//
//  URL+FailableCustomPersistable.swift
//
//  Created by Sereivoan Yong on 11/14/23.
//

import Foundation
import RealmSwift

extension URL: FailableCustomPersistable {

  public typealias PersistedType = String

  public init?(persistedValue: String) {
    self.init(string: persistedValue)
  }

  public var persistableValue: String {
    return absoluteString
  }
}
