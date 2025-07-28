//
//  KeychainInterface.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

import Foundation
import Security

/// CRUD for work with keychain.
public struct KeychainInterface: KeychainProtocol {
	let passwordQuery: PasswordProtocol

	public init(passwordQuery: any PasswordProtocol) {
		self.passwordQuery = passwordQuery
	}

	/// Add / Update password to Keychain.
	///
	/// - Parameters:
	///   - value: Secret data for storage.
	///   - key: Account name or key for stored data.
	/// - Throws: If the status is not `errSecSuccess`
	public func setValue(_ value: String, for key: String) throws {
		guard let encodedPassword = value.data(using: .utf8) else {
			throw KeychainError.string2DataConversionError
		}

		var query: [String: Any] = passwordQuery.query
		query[String(kSecAttrAccount)] = key

		// The status indicates whether the data was found successfully or failed.
		var status: OSStatus = SecItemCopyMatching(query as CFDictionary, nil)
		switch status {
		case errSecSuccess:	// data exists
			var attributesToUpdate: [String: Any] = [:]
			attributesToUpdate[String(kSecValueData)] = encodedPassword

			// Override status
			// Update the item identified by query, overriding the previous value
			status = SecItemUpdate(
				query as CFDictionary,
				attributesToUpdate as CFDictionary
			)
			if status != errSecSuccess {
				throw error(from: status)
			}
		case errSecItemNotFound:
			query[String(kSecValueData)] = encodedPassword

			// Override status
			// Add the item identified by the query to keychain
			status = SecItemAdd(query as CFDictionary, nil)
			if status != errSecSuccess {
				throw error(from: status)
			}
		default:
			throw error(from: status)
		}
	}

	/// Read password from Keychain.
	///
	/// - Parameter key: Account name or key for stored data.
	/// - Throws: If the status is `errSecItemNotFound` or not `errSecSuccess` or the found Data is not a String.
	/// - Returns: Founded password.
	public func getValue(for key: String) throws -> String? {
		var query: [String: Any] = passwordQuery.query
		query[String(kSecMatchLimit)] = kSecMatchLimitOne
		query[String(kSecReturnAttributes)] = kCFBooleanTrue
		query[String(kSecReturnData)] = kCFBooleanTrue
		query[String(kSecAttrAccount)] = key

		// The status indicates if the operation succeeded or failed.
		var queryResult: AnyObject?
		let status: OSStatus = withUnsafeMutablePointer(to: &queryResult) {
			SecItemCopyMatching(query as CFDictionary, $0)
		}

		switch status {
		case errSecSuccess:
			guard
				let queriedItem: [String: Any] = queryResult as? [String: Any],
				let passwordData: Data = queriedItem[String(kSecValueData)] as? Data,
				let password: String = .init(data: passwordData, encoding: .utf8)
			else {
				throw KeychainError.data2StringConversionError
			}
			return password
		case errSecItemNotFound:
			return nil
		default:
			throw error(from: status)
		}
	}

	/// Delete password from Keychain.
	///
	/// - Parameter key: Account name or key for stored data.
	/// - Throws: If the status is not `errSecSuccess` or not `errSecItemNotFound`
	public func removeValue(for key: String) throws {
		var query: [String: Any] = passwordQuery.query
		query[String(kSecMatchLimit)] = kSecMatchLimitOne
		query[String(kSecAttrAccount)] = key

		// The status indicates if the operation succeeded or failed.
		let status: OSStatus = SecItemDelete(query as CFDictionary)
		guard status == errSecSuccess || status == errSecItemNotFound else {
			throw error(from: status)
		}
	}

	@discardableResult
	/// Delete all passwords from Keychain.
	/// - Throws: If the status is not `errSecSuccess` or not `errSecItemNotFound`
	public func removeAllValues() throws -> Int {
		let query: [String: Any] = passwordQuery.query
		var count: Int = 0

		while true {
			let status: OSStatus = SecItemDelete(query as CFDictionary)
			if status == errSecItemNotFound {
				break
			}
			if status != errSecSuccess {
				throw error(from: status)
			}
			count += 1
		}
		return count
	}

	/// Return KeychainError with message.
	///
	/// - Parameter status: Keychain call completion status.
	/// - Returns: KeychainError
	private func error(from status: OSStatus) -> KeychainError {
		let message: String = SecCopyErrorMessageString(status, nil)
		as
		String? ?? NSLocalizedString("Unhandled Error", comment: "")

		return KeychainError.unhandledError(message: message)
	}
}
