//
//  Result.swift
//
//  Created by Sereivoan Yong on 1/24/20.
//

extension Result {
  
  @inlinable public init?(_ success: Success?, _ failure: Failure?) {
    if let success {
      self = .success(success)
    } else if let failure {
      self = .failure(failure)
    } else {
      return nil
    }
  }
  
  public var success: Success? {
    switch self {
    case .success(let success):
      return success
    case .failure:
      return nil
    }
  }
  
  public var failure: Failure? {
    switch self {
    case .success:
      return nil
    case .failure(let failure):
      return failure
    }
  }
}
