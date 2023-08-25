//
//  UIKitExtraTests.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

import XCTest
@testable import UIKitExtra

class UIKitExtraTests: XCTestCase {

  func testInitializerDefaults() {
    let textField = UITextField()
    let dateTextField = DateTextField(formatter: DateFormatter())
    XCTAssertEqual(textField.font, dateTextField.font)
    XCTAssertEqual(textField.textAlignment, dateTextField.textAlignment)
    XCTAssertEqual(textField.textColor, dateTextField.textColor)
    XCTAssertEqual(textField.placeholder, dateTextField.placeholder)

    let intTextField = IntTextField(value: nil)
    XCTAssertEqual(textField.font, intTextField.font)
    XCTAssertEqual(textField.textAlignment, intTextField.textAlignment)
    XCTAssertEqual(textField.textColor, intTextField.textColor)
    XCTAssertEqual(textField.placeholder, intTextField.placeholder)

    let decimalTextField = DecimalTextField(formatter: NumberFormatter(), value: nil)
    XCTAssertEqual(textField.font, decimalTextField.font)
    XCTAssertEqual(textField.textAlignment, decimalTextField.textAlignment)
    XCTAssertEqual(textField.textColor, decimalTextField.textColor)
    XCTAssertEqual(textField.placeholder, decimalTextField.placeholder)
  }
}
