//
//  Comparable.swift
//
//  Created by Sereivoan Yong on 9/24/20.
//

public protocol RangeExpressionInspectable: RangeExpression {
  
  var lowerBound: Bound { get }
  var upperBound: Bound { get }
}

extension ClosedRange: RangeExpressionInspectable { }
extension Range: RangeExpressionInspectable { }

extension Comparable {
  
  public func clamped<Range: RangeExpressionInspectable>(to limits: Range) -> Self where Range.Bound == Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
