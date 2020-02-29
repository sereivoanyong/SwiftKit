//
//  Result.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

extension Result {
  
  @inlinable public init?(_ success: Success?, _ failure: Failure?) {
    if let success = success {
      self = .success(success)
    } else if let failure = failure {
      self = .failure(failure)
    } else {
      return nil
    }
  }
}
