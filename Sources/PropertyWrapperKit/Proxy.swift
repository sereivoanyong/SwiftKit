//
//  Proxy.swift
//
//  Created by Sereivoan Yong on 7/16/21.
//

@propertyWrapper
public struct Proxy<Instance: AnyObject, Value> {

  private let keyPath: ReferenceWritableKeyPath<Instance, Value>

  public init(_ keyPath: ReferenceWritableKeyPath<Instance, Value>) {
    self.keyPath = keyPath
  }

  @available(*, unavailable)
  public var wrappedValue: Value {
    get { fatalError() }
    set { fatalError() }
  }

  public static subscript(
    _enclosingInstance instance: Instance,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<Instance, Value>,
    storage storageKeyPath: ReferenceWritableKeyPath<Instance, Self>
  ) -> Value {
    get { instance[keyPath: instance[keyPath: storageKeyPath].keyPath] }
    set { instance[keyPath: instance[keyPath: storageKeyPath].keyPath] = newValue }
  }
}
