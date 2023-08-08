//
//  KeychainProtocol.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 28.05.2023.
//

public protocol KeychainProtocol {
	func setValue(_ value: String, for key: String) throws
	func getValue(for key: String) throws -> String?
	func removeValue(for key: String) throws
	func removeAllValues() throws -> Int
}
