//
//  KeychainProtection.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 26.08.2026.
//

import Foundation
import Security

/// How well a stored secret is guarded.
///
/// Both of these keep the secret on the machine it was made on. What differs is whether reading it
/// costs anything: a token that only fetches prices should be readable while the person works,
/// while one that can spend their money is worth a moment of proving they are there.
public enum KeychainProtection: Sendable {

	/// Readable whenever the machine is unlocked, and never leaves it.
	///
	/// `ThisDeviceOnly` rather than the plain accessibility the keychain gives by default: without
	/// it the item travels in backups and onto the next Mac in a migration, which is not something
	/// a trading token should do quietly.
	case thisDeviceOnly

	/// Readable only when the person is there to say so.
	///
	/// The system decides how they say it, in this order: the built-in Touch ID, a Magic Keyboard
	/// with one, an Apple Watch, and failing all of those the account password. That is why the
	/// flag asked for is presence rather than biometry — a Mac mini has no sensor, and asking for
	/// biometry there does not fall back, it fails.
	///
	/// - Note: A machine nobody sits at cannot answer. Do not guard a secret this way when it has
	///   to be read while unattended.
	case userPresence
}

extension KeychainProtection {

	/// The attributes an item of this protection is created with.
	///
	/// - Returns: What to add to a keychain query.
	/// - Throws: ``KeychainError/accessControlFailed(message:)`` when the system refuses to build
	///   the access control — a policy this machine cannot satisfy at all.
	func attributes() throws -> [String: Any] {
		switch self {
		case .thisDeviceOnly:
			return [String(kSecAttrAccessible): kSecAttrAccessibleWhenUnlockedThisDeviceOnly]

		case .userPresence:
			var error: Unmanaged<CFError>?

			// The protection class travels inside the access control, so it is set here and not
			// beside it: an item carrying both is refused by the keychain.
			guard let control: SecAccessControl = SecAccessControlCreateWithFlags(
				nil,
				kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
				.userPresence,
				&error
			) else {
				let message: String = (error?.takeRetainedValue() as? any Error)?.localizedDescription
					?? "Unable to create access control"

				throw KeychainError.accessControlFailed(message: message)
			}

			return [String(kSecAttrAccessControl): control]
		}
	}
}
