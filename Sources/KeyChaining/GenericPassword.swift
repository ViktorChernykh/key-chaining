//
//  GenericPassword.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

import Foundation
import Security

public struct GenericPassword {
	let accessGroup: String?
	let service: String

	public init(accessGroup: String? = nil, service: String) {
		self.accessGroup = accessGroup
		self.service = service
	}
}

extension GenericPassword: PasswordProtocol {
	public var query: [String: Any] {
		var query: [String: Any] = [:]
		query[String(kSecClass)] = kSecClassGenericPassword
		query[String(kSecAttrService)] = service
		// Access group if target environment is not simulator
#if !targetEnvironment(simulator)
		if let accessGroup {
			query[String(kSecAttrAccessGroup)] = accessGroup
		}
#endif
		return query
	}
}
