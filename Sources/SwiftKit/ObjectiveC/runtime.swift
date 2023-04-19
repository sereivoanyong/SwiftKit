//
//  runtime.swift
//
//  Created by Sereivoan Yong on 10/29/17.
//

#if canImport(ObjectiveC)
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

extension NSObjectProtocol {
  
  // Value
  
  @inlinable public func associatedValue<Value>(forKey key: UnsafeRawPointer) -> Value? {
    return (objc_getAssociatedObject(self, key) as? Box<Value>)?.value
  }
  
  @inlinable public func associatedValue<Value>(forKey key: UnsafeRawPointer, default: @autoclosure () -> Value) -> Value {
    if let box = associatedObject(forKey: key) as Box<Value>? {
      return box.value
    } else {
      let `default` = `default`()
      setAssociatedValue(`default`, forKey: key)
      return `default`
    }
  }
  
  @inlinable public func setAssociatedValue<Value>(_ value: Value?, forKey key: UnsafeRawPointer) {
    if let value {
      if let box = associatedObject(forKey: key) as Box<Value>? {
        box.value = value
      } else {
        setAssociatedObject(Box<Value>(value), forKey: key, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
    } else {
      setAssociatedObject(nil as Box<Value>?, forKey: key, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  // Object
  
  @inlinable public func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? where T: AnyObject {
    return objc_getAssociatedObject(self, key) as? T
  }
  
  @inlinable public func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T, policy: @autoclosure () -> objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> T where T: AnyObject {
    if let object = objc_getAssociatedObject(self, key) as? T {
      return object
    } else {
      let `default` = `default`()
      setAssociatedObject(`default`, forKey: key, policy: policy())
      return `default`
    }
  }
  
  @inlinable public func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    objc_setAssociatedObject(self, key, object, policy)
  }
  
  @inlinable public func removeAssociatedObjects() {
    objc_removeAssociatedObjects(self)
  }
}
#endif
