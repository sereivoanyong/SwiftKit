//
//  CurrentValue.swift
//  SwiftKit
//
//  Created by Sereivoan Yong on 1/18/26.
//

import Combine

@available(iOS 13.0, *)
@propertyWrapper
public struct CurrentValue<Value> {

  public var wrappedValue: Value {
    get { projectedValue.value }
    nonmutating set { projectedValue.send(newValue) }
  }

  public let projectedValue: CurrentValueSubject<Value, Never>

  public var cancellable: AnyCancellable?

  public init(wrappedValue: Value) {
    self.projectedValue = CurrentValueSubject(wrappedValue)
  }
}
