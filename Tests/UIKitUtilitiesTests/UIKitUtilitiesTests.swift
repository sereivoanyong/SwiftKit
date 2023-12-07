//
//  UIKitUtilitiesTests.swift
//
//  Created by Sereivoan Yong on 5/30/21.
//

import XCTest
@testable import UIKitUtilities

class UIKitUtilitiesTests: XCTestCase {

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

  @available(iOS 15.0, *)
  func testButtonDefaults() {
    var configuration = UIButton.Configuration.plain()
    print("Corner Radius | Size & Corner Style")
    for size in UIButton.Configuration.Size.allCases {
      configuration.buttonSize = size
      for cornerStyle in UIButton.Configuration.CornerStyle.allCases {
        configuration.cornerStyle = cornerStyle
        print(size, cornerStyle, configuration.background.cornerRadius)
      }
    }

    print("Content Insets | Size & Corner Style")
    for size in UIButton.Configuration.Size.allCases {
      configuration.buttonSize = size
      configuration.setDefaultContentInsets()
      print(size, configuration.contentInsets)
    }
  }
}

@available(iOS 15.0, *)
extension UIButton.Configuration.Size: CaseIterable {

  public static let allCases: [Self] = [.mini, .small, .medium, .large]
}

@available(iOS 15.0, *)
extension UIButton.Configuration.CornerStyle: CaseIterable {

  public static let allCases: [Self] = [.fixed, .dynamic, .small, .medium, .large, .capsule]
}
