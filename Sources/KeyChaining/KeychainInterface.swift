//
//  KeychainInterface.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

import Foundation
import LocalAuthentication
import Security

/// CRUD for work with keychain.
public struct KeychainInterface: KeychainProtocol {
	private let passwordQuery: any PasswordProtocol

	// MARK: - Init
	public init(passwordQuery: any PasswordProtocol) {
		self.passwordQuery = passwordQuery
	}

	/// Set / Update password to Keychain.
	///
	/// - Parameters:
	///   - value: Secret data for storage.
	///   - key: Account name or key for stored data.
	///   - protection: How well the secret is guarded. See ``KeychainProtection``.
	/// - Throws: If the status is not `errSecSuccess`.
	public func setValue(
		_ value: String,
		for key: String,
		protection: KeychainProtection = .thisDeviceOnly
	) throws {
		guard let encodedPassword: Data = value.data(using: .utf8) else {
			throw KeychainError.string2DataConversionError
		}

		var query: [String: Any] = passwordQuery.query
		query[String(kSecAttrAccount)] = key

		let attributes: [String: Any] = try protection.attributes()

		// Presence is asked for at the moment of reading, so the item has to be made carrying it:
		// an item written without one cannot be given an access control afterwards. Writing over
		// a secret is not a reason to make the person prove anything, and deleting first does not
		// ask them to.
		if case .userPresence = protection {
			try removeValue(for: key)

			var insert: [String: Any] = query
			insert[String(kSecValueData)] = encodedPassword
			insert.merge(attributes) { _, new in new }

			let status: OSStatus = SecItemAdd(insert as CFDictionary, nil)
			if status != errSecSuccess {
				throw error(from: status)
			}

			return
		}

		// The status indicates whether the data was found successfully or failed.
		var status: OSStatus = SecItemCopyMatching(query as CFDictionary, nil)
		switch status {
		case errSecSuccess:	// data exists
			// The protection travels with the value: an item written before this package asked
			// for one is brought up to it here rather than being left as it was made.
			var attributesToUpdate: [String: Any] = [String(kSecValueData): encodedPassword]
			attributesToUpdate.merge(attributes) { _, new in new }

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
			query.merge(attributes) { _, new in new }

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

	/// Brings every stored secret up to a protection.
	///
	/// For items written before the protection was asked for. One call: `SecItemUpdate` changes
	/// every item its query matches, and the query here names the whole store.
	///
	/// - Parameter protection: What to bring them up to. A protection that asks for presence is
	///   refused here — that one has to be chosen per secret, when it is written.
	/// - Throws: If the status is not `errSecSuccess` or `errSecItemNotFound`.
	public func upgradeProtection(to protection: KeychainProtection = .thisDeviceOnly) throws {
		guard case .thisDeviceOnly = protection else {
			throw KeychainError.accessControlFailed(
				message: "Presence has to be chosen for one secret at a time"
			)
		}

		let status: OSStatus = SecItemUpdate(
			passwordQuery.query as CFDictionary,
			try protection.attributes() as CFDictionary
		)

		guard status == errSecSuccess || status == errSecItemNotFound else {
			throw error(from: status)
		}
	}

	/// Read password from Keychain.
	///
	/// - Parameters:
	///   - key: Account name or key for stored data.
	///   - context: What the system asks presence with, for a secret that requires it.
	/// - Throws: If the status is `errSecItemNotFound` or not `errSecSuccess` or the found Data is not a String.
	/// - Returns: Founded password.
	public func getValue(for key: String, context: LAContext? = nil) throws -> String? {
		var query: [String: Any] = passwordQuery.query
		query[String(kSecMatchLimit)] = kSecMatchLimitOne
		query[String(kSecReturnAttributes)] = kCFBooleanTrue
		query[String(kSecReturnData)] = kCFBooleanTrue
		query[String(kSecAttrAccount)] = key

		// Only a secret that was written asking for presence prompts, and then the context is what
		// carries the reason the person is shown and how long one answer counts for. Without one
		// the system asks in its own words.
		if let context {
			query[String(kSecUseAuthenticationContext)] = context
		}

		// The status indicates if the operation succeeded or failed.
		var queryResult: AnyObject?
		let status: OSStatus = withUnsafeMutablePointer(to: &queryResult) {
			SecItemCopyMatching(query as CFDictionary, $0)
		}

		switch status {
		case errSecSuccess:
			guard
				let queriedItem: [String: Any] = queryResult as? [String: Any],
				var passwordData: Data = queriedItem[String(kSecValueData)] as? Data,
				let password: String = .init(data: passwordData, encoding: .utf8)
			else {
				throw KeychainError.data2StringConversionError
			}
			// Zeroize of passwordData
			defer {
				passwordData.resetBytes(in: 0..<passwordData.count)
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
	/// - Throws: If the status is not `errSecSuccess` or not `errSecItemNotFound`.
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

	/// Delete all passwords from Keychain.
	///
	/// - Returns: The value is `true` if the value is deleted, otherwise `false` is returned.
	/// - Throws: If the status is not `errSecSuccess` or not `errSecItemNotFound`.
	@discardableResult
	public func removeAllValues() throws -> Int {
		let query: [String: Any] = passwordQuery.query
		var count: Int = 0

		while true {
			let status: OSStatus = SecItemDelete(query as CFDictionary)
			if status == errSecSuccess {
				count += 1
			} else if status == errSecItemNotFound {
				break
			} else {
				throw error(from: status)
			}
		}
		return count
	}

	/// Return KeychainError with message.
	///
	/// - Parameter status: Keychain call completion status.
	/// - Returns: KeychainError.
	private func error(from status: OSStatus) -> KeychainError {
		let message: String = SecCopyErrorMessageString(status, nil)
		as
		String? ?? NSLocalizedString("Unhandled Error", comment: "")

		return KeychainError.unhandledError(message: message)
	}
}
