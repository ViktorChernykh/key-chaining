//
//  InternetPassword.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

import Foundation
import Security

public struct InternetPassword {
	let accessGroup: String?
	let server: String
	let port: Int?
	let path: String?
	let securityDomain: String?
	let internetProtocol: InternetProtocol?
	let internetAuthenticationType: InternetAuthenticationType?

	init(
		accessGroup: String? = nil,
		server: String,
		port: Int? = nil,
		path: String? = nil,
		securityDomain: String? = nil,
		internetProtocol: InternetProtocol? = nil,
		internetAuthenticationType: InternetAuthenticationType? = nil
	) {
		self.accessGroup = accessGroup
		self.server = server
		self.port = port
		self.path = path
		self.securityDomain = securityDomain
		self.internetProtocol = internetProtocol
		self.internetAuthenticationType = internetAuthenticationType
	}
}

extension InternetPassword: PasswordProtocol {
	public var query: [String: Any] {
		var query: [String: Any] = [:]
		query[String(kSecClass)] = kSecClassInternetPassword
		query[String(kSecAttrAccessGroup)] = accessGroup
		query[String(kSecAttrServer)] = server
		query[String(kSecAttrPort)] = port
		query[String(kSecAttrPath)] = path
		query[String(kSecAttrSecurityDomain)] = securityDomain
		query[String(kSecAttrProtocol)] = internetProtocol?.rawValue
		query[String(kSecAttrAuthenticationType)] = internetAuthenticationType?.rawValue
		return query
	}
}
