//
//  Passthrough.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 2/1/25.
//

import Foundation
import Combine

@available(iOS 13.0, *)
@propertyWrapper
final public class Passthrough<T: Equatable> {

  public let subject = PassthroughSubject<T, Never>()

  public var wrappedValue: T {
    didSet {
      if wrappedValue != oldValue {
        subject.send(wrappedValue)
      }
    }
  }

  public init(wrappedValue: T) {
    self.wrappedValue = wrappedValue
  }

  public var projectedValue: PassthroughSubject<T, Never> {
    return subject
  }
}
