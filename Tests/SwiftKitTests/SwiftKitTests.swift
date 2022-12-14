import XCTest
@testable import SwiftKit

final class SwiftKitTests: XCTestCase {

  func testPreferenceStore() throws {
    let stores: [PreferenceStore] = [UserDefaults.standard /*, NSUbiquitousKeyValueStore.default */]
    let values: [any Equatable & PropertyListObject] = [
      "A",
      1 as Int,
      1.1 as Float,
      1.2 as Double,
      false as Bool,
      Date(),
      Data(),
      Array<Int>(),
      Dictionary<String, Int>()
    ]
    
    struct EqualityChecker {

      let isEqual: (Any) -> Bool

      init<T: Equatable & PropertyListObject>(_ value: T) {
        isEqual = { otherValue in
          print(type(of: value), type(of: otherValue))
          return otherValue as! T == value
        }
      }
    }

    for store in stores {
      for value in values {
        store["value"] = value
        let checker = EqualityChecker(value)
        XCTAssert(checker.isEqual(store["value"]!))
      }
    }
  }
}
