import XCTest
@testable import PropertyWrapperKit
@testable import SwiftKit

struct Person: Codable {

  let age: Int
  let gender: Gender
}

class CodingPerson: NSObject, NSCoding {

  override init() {

  }

  required init?(coder: NSCoder) {
  }

  func encode(with coder: NSCoder) {
  }
}

enum Gender: String, Codable {

  case male, female
}

final class PropertyWrapperKitTests: XCTestCase {

  @UserDefault(key: "Key")
  var gender: Gender?

  @UserDefault(key: "Key", coder: .json())
  var jsonPerson: Person?

  @UserDefault(key: "Key", coder: .json())
  var propertyListPerson: Person?

  @Storage("OptionalAge2", store: UserDefaults.standard)
  var optionalAge2: Int?

  @Storage("Age2", default: 10, store: UserDefaults.standard)
  var age2: Int

  @Storage("OptionalGender2", store: UserDefaults.standard)
  var optionalGender2: Gender?

  @Storage("Gender2", default: .male, store: UserDefaults.standard)
  var gender2: Gender

  @Storage("OptionalPerson2", store: UserDefaults.standard, transforming: .jsonCoding())
  var optionalPerson2: Person?

  @Storage("Person2", default: Person(age: 10, gender: .male), store: UserDefaults.standard, transforming: .jsonCoding())
  var person2: Person

  @Storage("OptionalPerson3", store: UserDefaults.standard, transforming: .propertyListCoding())
  var optionalPerson3: Person?

  @Storage("Person3", default: Person(age: 10, gender: .male), store: UserDefaults.standard, transforming: .propertyListCoding())
  var person3: Person

  @Storage("OptionalPerson4", store: UserDefaults.standard, transforming: .keyedArchiving(requiringSecureCoding: false))
  var optionalPerson4: CodingPerson?

  @Storage("Person4", default: CodingPerson(), store: UserDefaults.standard, transforming: .keyedArchiving(requiringSecureCoding: false))
  var person4: CodingPerson

  @Storage("OptionalPerson5", store: UserDefaults.standard, transforming: .jsonSerializing())
  var optionalPerson5: [String: Any]?

  @Storage("Person5", default: [:], store: UserDefaults.standard, transforming: .jsonSerializing())
  var person5: [String: Any]
}
