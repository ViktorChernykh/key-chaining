//
//  PasswordProtocol.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

/// Protocol representing a keychain password query.
/// Conforming types must provide a dictionary of query parameters for keychain operations.
public protocol PasswordProtocol: Sendable {
	var query: [String: Any] { get }
}
