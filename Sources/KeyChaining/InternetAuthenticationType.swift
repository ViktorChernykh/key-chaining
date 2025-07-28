//
//  InternetAuthenticationType.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

import Foundation
import Security

public enum InternetAuthenticationType: RawRepresentable {
	case ntlm, msn, dpa, rpa, httpBasic, httpDigest, htmlForm, `default`

	public init?(rawValue: String) {
		switch rawValue {
		case String(kSecAttrAuthenticationTypeNTLM):
			self = .ntlm
		case String(kSecAttrAuthenticationTypeMSN):
			self = .msn
		case String(kSecAttrAuthenticationTypeDPA):
			self = .dpa
		case String(kSecAttrAuthenticationTypeRPA):
			self = .rpa
		case String(kSecAttrAuthenticationTypeHTTPBasic):
			self = .httpBasic
		case String(kSecAttrAuthenticationTypeHTTPDigest):
			self = .httpDigest
		case String(kSecAttrAuthenticationTypeHTMLForm):
			self = .htmlForm
		case String(kSecAttrAuthenticationTypeDefault):
			self = .default
		default:
			self = .default
		}
	}

	public var rawValue: String {
		switch self {
		case .ntlm:
			 String(kSecAttrAuthenticationTypeNTLM)
		case .msn:
			String(kSecAttrAuthenticationTypeMSN)
		case .dpa:
			String(kSecAttrAuthenticationTypeDPA)
		case .rpa:
			String(kSecAttrAuthenticationTypeRPA)
		case .httpBasic:
			String(kSecAttrAuthenticationTypeHTTPBasic)
		case .httpDigest:
			String(kSecAttrAuthenticationTypeHTTPDigest)
		case .htmlForm:
			String(kSecAttrAuthenticationTypeHTMLForm)
		case .default:
			String(kSecAttrAuthenticationTypeDefault)
		}
	}
}
