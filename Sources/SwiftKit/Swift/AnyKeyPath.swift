//
//  AnyKeyPath.swift
//
//  Created by Sereivoan Yong on 10/15/20.
//

extension AnyKeyPath {
  
  /// - seealso: https://github.com/apple/swift/blob/aa3e5904f8ba8bf9ae06d96946774d171074f6e5/stdlib/public/Darwin/Foundation/NSObject.swift#L154
  @inlinable public var string: String? {
    return _kvcKeyPathString
  }
}
