import XCTest
@testable import PropertyWrapperKit

struct Person: Codable {

}

enum Gender: String {

  case male, female
}

final class PropertyWrapperKitTests: XCTestCase {

  @UserDefault(key: "Key")
  var gender: Gender?

  @UserDefault(key: "Key", coder: .json())
  var jsonPerson: Person?

  @UserDefault(key: "Key", coder: .json())
  var propertyListPerson: Person?
}
