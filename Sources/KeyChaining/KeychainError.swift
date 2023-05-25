//
//  KeychainError.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

import Foundation

public enum KeychainError: Error {
	case string2DataConversionError
	case data2StringConversionError
	case unhandledError(message: String)
}

extension KeychainError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .string2DataConversionError:
			return NSLocalizedString("String to Data conversion error", comment: "")
		case .data2StringConversionError:
			return NSLocalizedString("Data to String conversion error", comment: "")
		case .unhandledError(let message):
			return NSLocalizedString(message, comment: "")
		}
	}
}
