//
//  KeychainProtocol.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 28.05.2023.
//

public protocol KeychainProtocol {
	func setPassword(_ password: String, for account: String) throws
	func getPassword(for account: String) throws -> String?
	func removePassword(for account: String) throws
	func removeAllPasswords() throws -> Int
}
