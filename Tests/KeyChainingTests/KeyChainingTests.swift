import XCTest
@testable import KeyChaining

final class KeyChainingTests: XCTestCase {
	var genericPasswordKeychain: KeychainInterface!
	var internetPasswordKeychain: KeychainInterface!

	override func setUp() {
		super.setUp()

		let genericPasswordQuery = GenericPassword(
			accessGroup: "someGroup",
			service: "MyService")
		genericPasswordKeychain = KeychainInterface(passwordQuery: genericPasswordQuery)

		let internetPasswordQuery = InternetPassword(
			accessGroup: "someGroup",
			server: "someServer",
			port: 8080,
			path: "somePath",
			securityDomain: "someDomain",
			internetProtocol: .https,
			internetAuthenticationType: .httpBasic)

		internetPasswordKeychain = KeychainInterface(passwordQuery: internetPasswordQuery)
	}

	override func tearDown() {
		_ = try? genericPasswordKeychain.removeAllValues()
		_ = try? internetPasswordKeychain.removeAllValues()

		super.tearDown()
	}

	func testSaveGenericPassword() {
		do {
			try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
		} catch (let error) {
			XCTFail("Saving generic password failed with \(error.localizedDescription)")
		}
	}

	func testReadGenericPassword() {
		do {
			// Given
			try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")

			// When
			let password = try genericPasswordKeychain.getValue(for: "genericAccount")

			// Then
			XCTAssertEqual("pwd_1234", password)
		} catch (let error) {
			XCTFail("Reading generic password failed with \(error.localizedDescription)")
		}
	}

	func testUpdateGenericPassword() {
		do {
			// Given
			try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
			try genericPasswordKeychain.setValue("pwd_1235", for: "genericAccount")

			// When
			let password = try genericPasswordKeychain.getValue(for: "genericAccount")

			// Then
			XCTAssertEqual("pwd_1235", password)
		} catch (let error) {
			XCTFail("Updating generic password failed with \(error.localizedDescription)")
		}
	}

	func testRemoveGenericPassword() {
		do {
			// Given
			try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")

			// When
			try genericPasswordKeychain.removeValue(for: "genericAccount")

			// Then
			XCTAssertNil(try genericPasswordKeychain.getValue(for: "genericAccount"))
		} catch (let error) {
			XCTFail("Saving generic password failed with \(error.localizedDescription)")
		}
	}

	func testRemoveAllGenericPasswords() {
		do {
			// Given
			try genericPasswordKeychain.setValue("pwd_1234", for: "genericAccount")
			try genericPasswordKeychain.setValue("pwd_1235", for: "genericAccount2")

			// When
			let deletedCount = try genericPasswordKeychain.removeAllValues()

			// Then
			XCTAssertEqual(deletedCount, 2)
			XCTAssertNil(try genericPasswordKeychain.getValue(for: "genericAccount"))
			XCTAssertNil(try genericPasswordKeychain.getValue(for: "genericAccount2"))
		} catch (let error) {
			XCTFail("Removing generic passwords failed with \(error.localizedDescription)")
		}
	}

	func testSaveInternetPassword() {
		do {
			// Given
			try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")
		} catch (let error) {
			XCTFail("Saving Internet password failed with \(error.localizedDescription)")
		}
	}

	func testReadInternetPassword() {
		do {
			// Given
			try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")

			// When
			let password = try internetPasswordKeychain.getValue(for: "internetAccount")

			// Then
			XCTAssertEqual("pwd_1234", password)
		} catch (let error) {
			XCTFail("Reading Internet password failed with \(error.localizedDescription)")
		}
	}

	func testUpdateInternetPassword() {
		do {
			// Given
			try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")
			try internetPasswordKeychain.setValue("pwd_1235", for: "internetAccount")

			// When
			let password = try internetPasswordKeychain.getValue(for: "internetAccount")

			// Then
			XCTAssertEqual("pwd_1235", password)
		} catch (let error) {
			XCTFail("Updating Internet password failed with \(error.localizedDescription)")
		}
	}

	func testRemoveInternetPassword() {
		do {
			// Given
			try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")

			// When
			try internetPasswordKeychain.removeValue(for: "internetAccount")

			// Then
			XCTAssertNil(try internetPasswordKeychain.getValue(for: "internetAccount"))
		} catch (let error) {
			XCTFail("Removing Internet password failed with \(error.localizedDescription)")
		}
	}

	func testRemoveAllInternetPasswords() {
		do {
			// Given
			try internetPasswordKeychain.setValue("pwd_1234", for: "internetAccount")
			try internetPasswordKeychain.setValue("pwd_1235", for: "internetAccount2")

			// When
			let deletedCount = try internetPasswordKeychain.removeAllValues()

			// Then
			XCTAssertEqual(deletedCount, 2)
			XCTAssertNil(try internetPasswordKeychain.getValue(for: "internetAccount"))
			XCTAssertNil(try internetPasswordKeychain.getValue(for: "internetAccount2"))
		} catch (let error) {
			XCTFail("Removing Internet passwords failed with \(error.localizedDescription)")
		}
	}
}
