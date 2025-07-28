//
//  KeychainProtocol.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 28.05.2023.
//

/// Protocol defining basic keychain operations for storing, retrieving, and removing values.
public protocol KeychainProtocol: Sendable {
	func setValue(_ value: String, for key: String) throws
	func getValue(for key: String) throws -> String?
	func removeValue(for key: String) throws
	func removeAllValues() throws -> Int
}
