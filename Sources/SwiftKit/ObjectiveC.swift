//
//  ObjectiveC.swift
//
//  Created by Sereivoan Yong on 10/29/17.
//

#if canImport(ObjectiveC)
import ObjectiveC

// MARK: - Swizzle

public func class_exchangeClassMethodImplementations(_ cls: AnyClass, _ selector1: Selector, _ selector2: Selector) {
  let method1 = class_getClassMethod(cls, selector1).unsafelyUnwrapped
  let method2 = class_getClassMethod(cls, selector2).unsafelyUnwrapped
  method_exchangeImplementations(method1, method2)
}

public func class_exchangeInstanceMethodImplementations(_ cls: AnyClass, _ selector1: Selector, _ selector2: Selector) {
  let method1 = class_getInstanceMethod(cls, selector1).unsafelyUnwrapped
  let method2 = class_getInstanceMethod(cls, selector2).unsafelyUnwrapped
  method_exchangeImplementations(method1, method2)
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
    if let value = value {
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

extension NSObjectProtocol {
  
  @discardableResult
  @inlinable public func configure(_ handler: (Self) -> Void) -> Self {
    handler(self)
    return self
  }
  
  @discardableResult
  @inlinable public func performIfResponds(_ selector: Selector) -> Unmanaged<AnyObject>? {
    if responds(to: selector) {
      return perform(selector)
    }
    return nil
  }
  
  @discardableResult
  @inlinable public func performIfResponds(_ selector: Selector, with object: Any?) -> Unmanaged<AnyObject>? {
    if responds(to: selector) {
      return perform(selector, with: object)
    }
    return nil
  }
  
  public func first(where predicate: (Self) throws -> Bool, next: (Self) throws -> Self?) rethrows -> Self? {
    var currentTarget: Self? = self
    while let target = currentTarget {
      if try predicate(target) {
        return target
      }
      currentTarget = try next(target)
    }
    return nil
  }
  
  public func first<T>(ofType type: T.Type, next: (Self) throws -> Self?) rethrows -> T? {
    return try first(ofType: type, where: { _ in true }, next: next)
  }
  
  public func first<T>(ofType type: T.Type, where predicate: (T) throws -> Bool, next: (Self) throws -> Self?) rethrows -> T? {
    var currentTarget: Self? = self
    while let target = currentTarget {
      if let castedTarget = target as? T, try predicate(castedTarget) {
        return castedTarget
      }
      currentTarget = try next(target)
    }
    return nil
  }
}
#endif
