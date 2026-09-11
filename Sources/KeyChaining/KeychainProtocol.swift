//
//  KeychainProtocol.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 28.05.2023.
//

import LocalAuthentication

/// Protocol defining basic keychain operations for storing, retrieving, and removing values.
public protocol KeychainProtocol: Sendable {

	/// - Parameter protection: How well the secret is guarded. See ``KeychainProtection``.
	func setValue(_ value: String, for key: String, protection: KeychainProtection) throws

	/// - Parameter context: What the system asks presence with, for a secret that requires it —
	///   carrying the reason shown to the person and how long one answer counts for.
	func getValue(for key: String, context: LAContext?) throws -> String?
	func removeValue(for key: String) throws
	func removeAllValues() throws -> Int

	/// Brings every stored secret up to a protection, for items written before it was asked for.
	func upgradeProtection(to protection: KeychainProtection) throws
}

public extension KeychainProtocol {

	func setValue(_ value: String, for key: String) throws {
		try setValue(value, for: key, protection: .thisDeviceOnly)
	}

	func getValue(for key: String) throws -> String? {
		try getValue(for: key, context: nil)
	}
}
