//
//  runtime.swift
//
//  Created by Sereivoan Yong on 10/29/17.
//

import ObjectiveC

// MARK: - Swizzle

public func class_exchangeClassMethodImplementations(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
  let originalMethod = class_getClassMethod(cls, originalSelector).unsafelyUnwrapped
  let swizzledMethod = class_getClassMethod(cls, swizzledSelector).unsafelyUnwrapped
  method_exchangeImplementations(originalMethod, swizzledMethod)
}

public func class_exchangeInstanceMethodImplementations(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
  let originalMethod = class_getInstanceMethod(cls, originalSelector).unsafelyUnwrapped
  let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector).unsafelyUnwrapped
  let wasMethodAdded = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
  if wasMethodAdded {
    class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }
}

// MARK: Modernize

@inlinable
public func associatedObject<T: AnyObject>(
  default defaultObject: @autoclosure () -> T,
  forKey key: UnsafeRawPointer,
  with source: AnyObject,
  policy: @autoclosure () -> objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
) -> T {
  return associatedObject(default: defaultObject, forKey: key, with: source, policy: policy)
}

@inlinable
public func associatedObject<T: AnyObject>(
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) -> T? {
  return objc_getAssociatedObject(source, key) as? T
}

@inlinable
public func setAssociatedObject<T: AnyObject>(
  _ newObject: T?,
  forKey key: UnsafeRawPointer,
  with source: AnyObject,
  policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
) {
  objc_setAssociatedObject(source, key, newObject, policy)
}

@inlinable
public func removeAssociatedObjects(with source: AnyObject) {
  objc_removeAssociatedObjects(source)
}

// MARK: Weak Object

public func associatedWeakObject<T: AnyObject>(
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) -> T? {
  return (objc_getAssociatedObject(source, key) as? WeakReference<T>)?.object
}

public func setAssociatedWeakObject<T: AnyObject>(
  _ newObject: T?,
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) {
  objc_setAssociatedObject(source, key, newObject.map(WeakReference<T>.init), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

// MARK: Value

public func associatedValue<T>(
  default defaultValue: @autoclosure () -> T,
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) -> T {
  return associatedReference(default: defaultValue, forKey: key, with: source).value
}

public func associatedValue<T>(forKey key: UnsafeRawPointer, with source: AnyObject) -> T? {
  if let reference = associatedReference(forKey: key, with: source) as Reference<T>? {
    return reference.value
  }
  return nil
}

public func setAssociatedValue<T>(_ newValue: T?, forKey key: UnsafeRawPointer, with source: AnyObject) {
  setAssociatedReference(newValue.map(Reference.init), forKey: key, with: source)
}

// MARK: Reference (Internal)

@inlinable
func associatedObject<T: AnyObject>(
  default defaultObject: () -> T,
  forKey key: UnsafeRawPointer,
  with source: AnyObject,
  policy: () -> objc_AssociationPolicy
) -> T {
  if let object = objc_getAssociatedObject(source, key) as? T {
    return object
  } else {
    let object = defaultObject()
    setAssociatedObject(object, forKey: key, with: source, policy: policy())
    return object
  }
}

@inlinable
func associatedReference<T>(
  default defaultValue: () -> T,
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) -> Reference<T> {
  return associatedObject(default: { Reference(defaultValue()) }, forKey: key, with: source, policy: { .OBJC_ASSOCIATION_RETAIN_NONATOMIC })
}

func associatedReference<T>(
  default defaultValue: @autoclosure () -> T,
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) -> Reference<T> {
  return associatedReference(default: defaultValue, forKey: key, with: source)
}

func associatedReference<T>(
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) -> Reference<T>? {
  return associatedObject(forKey: key, with: source)
}

func setAssociatedReference<T>(
  _ reference: Reference<T>?,
  forKey key: UnsafeRawPointer,
  with source: AnyObject
) {
  setAssociatedObject(reference, forKey: key, with: source, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

final private class WeakReference<T: AnyObject> {

  weak var object: T?

  init(object: T) {
    self.object = object
  }
}
