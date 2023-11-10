//
//  StepperTextField.swift
//
//  Created by Sereivoan Yong on 8/23/20.
//

#if os(iOS)

import UIKit

open class StepperTextField<Value>: NumberTextField<Value> where Value: _ObjectiveCBridgeable & Comparable & AdditiveArithmetic, Value._ObjectiveCType: NSNumber {

  open var stepValue: Value = .zero
  
  // MARK: Control Events

  @IBAction open func incrementValue(_ sender: Any) {
    resignFirstResponder()
    if let value = value {
      let steppedValue = value + stepValue
      if let maximumValue = maximumValue {
        if steppedValue <= maximumValue {
          setValue(steppedValue, sendValueChangedActions: true)
        }
      } else {
        setValue(steppedValue, sendValueChangedActions: true)
      }
    } else {
      setValue(.zero, sendValueChangedActions: true)
    }
  }

  @IBAction open func decrementValue(_ sender: Any) {
    resignFirstResponder()
    if let value = value {
      let steppedValue = value - stepValue
      if let minimumValue = minimumValue {
        if steppedValue >= minimumValue {
          setValue(steppedValue, sendValueChangedActions: true)
        }
      } else {
        setValue(steppedValue, sendValueChangedActions: true)
      }
    } else {
      setValue(.zero, sendValueChangedActions: true)
    }
  }
}

#endif
