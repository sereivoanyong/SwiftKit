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
public func associatedObject<T: AnyObject>(default defaultObject: @autoclosure () -> T, forKey key: UnsafeRawPointer, with source: AnyObject, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> T {
  if let object = objc_getAssociatedObject(source, key) as? T {
    return object
  }
  let object = defaultObject()
  setAssociatedObject(object, forKey: key, with: source, policy: policy)
  return object
}

@inlinable
public func associatedObject<T: AnyObject>( forKey key: UnsafeRawPointer, with source: AnyObject) -> T? {
  return objc_getAssociatedObject(source, key) as? T
}

@inlinable
public func setAssociatedObject<T: AnyObject>(_ newObject: T?, forKey key: UnsafeRawPointer, with source: AnyObject, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
  objc_setAssociatedObject(source, key, newObject, policy)
}

@inlinable
public func removeAssociatedObject(forKey key: UnsafeRawPointer, with source: AnyObject) {
  objc_setAssociatedObject(source, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

@inlinable
public func removeAssociatedObjects(with source: AnyObject) {
  objc_removeAssociatedObjects(source)
}

// MARK: Weak Object

@inlinable
public func associatedWeakObject<T: AnyObject>(forKey key: UnsafeRawPointer, with source: AnyObject) -> T? {
  if let reference = associatedObject(forKey: key, with: source) as WeakReference? {
    return reference.base as? T
  }
  return nil
}

@inlinable
public func setAssociatedWeakObject(_ newObject: AnyObject?, forKey key: UnsafeRawPointer, with source: AnyObject) {
  setAssociatedObject(newObject.map(WeakReference.init), forKey: key, with: source)
}

// MARK: Value

@inlinable
public func associatedValue<T>(default defaultValue: @autoclosure () -> T, forKey key: UnsafeRawPointer, with source: AnyObject) -> T {
  if let value = associatedValue(forKey: key, with: source) as T? {
    return value
  }
  let value = defaultValue()
  setAssociatedValue(value, forKey: key, with: source)
  return value
}

@inlinable
public func associatedValue<T>(forKey key: UnsafeRawPointer, with source: AnyObject) -> T? {
  if let reference = associatedObject(forKey: key, with: source) as AnyReference? {
    return reference.base as? T
  }
  return nil
}

@inlinable
public func setAssociatedValue(_ newValue: Any?, forKey key: UnsafeRawPointer, with source: AnyObject) {
  setAssociatedObject(newValue.map(AnyReference.init), forKey: key, with: source)
}
