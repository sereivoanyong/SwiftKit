//
//  Utilities.swift
//
//  Created by Sereivoan Yong on 4/30/21.
//

#if os(iOS)

import ObjectiveC
import Foundation

@usableFromInline
func class_exchangeInstanceMethodImplementations(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
  let originalMethod = class_getInstanceMethod(cls, originalSelector).unsafelyUnwrapped
  let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector).unsafelyUnwrapped
  let wasMethodAdded = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
  if wasMethodAdded {
    class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }
}

@usableFromInline
func setValueIfNotEqual<Root, Value>(_ value: Value, for keyPath: ReferenceWritableKeyPath<Root, Value>, on object: Root) where Value: Equatable {
  if object[keyPath: keyPath] != value {
    object[keyPath: keyPath] = value
  }
}

extension NSObjectProtocol where Self: NSObject {

  func bind<Target, Value>(_ keyPath: KeyPath<Self, Value>, to target: Target, at targetKeyPath: ReferenceWritableKeyPath<Target, Value>) -> NSKeyValueObservation {
    observe(keyPath, options: [.initial, .new]) { source, _ in
      target[keyPath: targetKeyPath] = source[keyPath: keyPath]
    }
  }

  func bind<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>, to target: Self) -> NSKeyValueObservation {
    observe(keyPath, options: [.initial, .new]) { source, _ in
      target[keyPath: keyPath] = source[keyPath: keyPath]
    }
  }
}

extension NSKeyValueObservation {

  final func store<C>(in collection: inout C) where C: RangeReplaceableCollection, C.Element == NSKeyValueObservation {
    collection.append(self)
  }
}

extension Optional {

  @discardableResult
  func assignIfNonNil<Root>(to keyPath: ReferenceWritableKeyPath<Root, Wrapped>, on object: Root) -> Bool {
    if let value = self {
      object[keyPath: keyPath] = value
      return true
    }
    return false
  }

  @discardableResult
  func assignIfNonNil<Root>(to keyPath: ReferenceWritableKeyPath<Root, Wrapped?>, on object: Root) -> Bool {
    if let value = self {
      object[keyPath: keyPath] = value
      return true
    }
    return false
  }
}

#endif
