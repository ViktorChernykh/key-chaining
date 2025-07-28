import XCTest
@testable import KeyChaining

final class KeyChainingTests: XCTestCase {
	var genericPasswordKeychain: KeychainInterface!
	var internetPasswordKeychain: KeychainInterface!

	override func setUp() {
		super.setUp()

		let genericPasswordQuery: GenericPassword = .init(
			accessGroup: "someGroup",
			service: "MyService"
		)
		genericPasswordKeychain = KeychainInterface(passwordQuery: genericPasswordQuery)

		let internetPasswordQuery: InternetPassword = .init(
			accessGroup: "someGroup",
			server: "someServer",
			port: 8080,
			path: "somePath",
			securityDomain: "someDomain",
			internetProtocol: .https,
			internetAuthenticationType: .httpBasic
		)
		internetPasswordKeychain = KeychainInterface(passwordQuery: internetPasswordQuery)
	}

	override func tearDown() {
		_ = try? genericPasswordKeychain.removeAllValues()
		_ = try? internetPasswordKeychain.removeAllValues()

		super.tearDown()
	}

	func testSaveGenericPassword() throws {
		try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
	}

	func testReadGenericPassword() throws {
		// Given
		try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
		try genericPasswordKeychain.setValue("pwd_1235", for: "genericAccount2")

		// When
		let password: String? = try genericPasswordKeychain.getValue(for: "genericAccount")
		let password2: String? = try genericPasswordKeychain.getValue(for: "genericAccount2")

		// Then
		XCTAssertEqual("pwd_1234", password)
		XCTAssertEqual("pwd_1235", password2)
	}

	func testUpdateGenericPassword() throws {
		// Given
		try genericPasswordKeychain.setValue("pwd_123", for: "genericAccount2")
		try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
		try genericPasswordKeychain.setValue("pwd_1235", for: "genericAccount")

		// When
		let password: String? = try genericPasswordKeychain.getValue(for: "genericAccount")
		let password2: String? = try genericPasswordKeychain.getValue(for: "genericAccount2")

		// Then
		XCTAssertEqual("pwd_1235", password)
		XCTAssertEqual("pwd_123", password2)
	}

	func testRemoveGenericPassword() throws {
		// Given
		try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
		try genericPasswordKeychain.setValue("pwd_123", for: "genericAccount2")

		// When
		try genericPasswordKeychain.removeValue(for: "genericAccount")
		let password: String? = try genericPasswordKeychain.getValue(for: "genericAccount")
		let password2: String? = try genericPasswordKeychain.getValue(for: "genericAccount2")

		// Then
		XCTAssertNil(password)
		XCTAssertEqual("pwd_123", password2)
	}

	func testRemoveAllGenericPasswords() throws {
		// Given
		try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
		try genericPasswordKeychain.setValue("pwd_1235", for: "genericAccount2")

		// When
		let deletedCount: Int = try genericPasswordKeychain.removeAllValues()

		// Then
		XCTAssertEqual(deletedCount, 2)
		XCTAssertNil(try genericPasswordKeychain.getValue(for: "genericAccount"))
		XCTAssertNil(try genericPasswordKeychain.getValue(for: "genericAccount2"))
	}

	func testSaveInternetPassword() throws {
		// Given
		try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")
	}

	func testReadInternetPassword() throws {
		// Given
		try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")

		// When
		let password: String? = try internetPasswordKeychain.getValue(for: "internetAccount")

		// Then
		XCTAssertEqual("pwd_1234", password)
	}

	func testUpdateInternetPassword() throws {
		// Given
		try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")
		try internetPasswordKeychain.setValue("pwd_1235", for: "internetAccount")

		// When
		let password: String? = try internetPasswordKeychain.getValue(for: "internetAccount")

		// Then
		XCTAssertEqual("pwd_1235", password)
	}

	func testRemoveInternetPassword() throws {
		// Given
		try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")

		// When
		try internetPasswordKeychain.removeValue(for: "internetAccount")

		// Then
		XCTAssertNil(try internetPasswordKeychain.getValue(for: "internetAccount"))
	}

	func testRemoveAllInternetPasswords() throws {
		// Given
		try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")
		try internetPasswordKeychain.setValue("pwd_1235", for: "internetAccount2")

		// When
		let deletedCount: Int = try internetPasswordKeychain.removeAllValues()

		// Then
		XCTAssertEqual(deletedCount, 2)
		XCTAssertNil(try internetPasswordKeychain.getValue(for: "internetAccount"))
		XCTAssertNil(try internetPasswordKeychain.getValue(for: "internetAccount2"))
	}
}
