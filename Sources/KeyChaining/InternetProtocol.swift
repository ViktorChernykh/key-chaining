//
//  InternetProtocol.swift
//  KeyChaining
//
//  Created by Victor Chernykh on 05.05.2023.
//

import Foundation
import Security

public enum InternetProtocol: RawRepresentable {
	case ftp, ftpAccount, http, irc, nntp, pop3, smtp, socks, imap, ldap, appleTalk, afp, telnet, ssh, ftps, https, httpProxy, httpsProxy, ftpProxy, smb, rtsp, rtspProxy, daap, eppc, ipp, nntps, ldaps, telnetS, imaps, ircs, pop3S

	public init?(rawValue: String) {
		switch rawValue {
		case String(kSecAttrProtocolFTP):
			self = .ftp
		case String(kSecAttrProtocolFTPAccount):
			self = .ftpAccount
		case String(kSecAttrProtocolHTTP):
			self = .http
		case String(kSecAttrProtocolIRC):
			self = .irc
		case String(kSecAttrProtocolNNTP):
			self = .nntp
		case String(kSecAttrProtocolPOP3):
			self = .pop3
		case String(kSecAttrProtocolSMTP):
			self = .smtp
		case String(kSecAttrProtocolSOCKS):
			self = .socks
		case String(kSecAttrProtocolIMAP):
			self = .imap
		case String(kSecAttrProtocolLDAP):
			self = .ldap
		case String(kSecAttrProtocolAppleTalk):
			self = .appleTalk
		case String(kSecAttrProtocolAFP):
			self = .afp
		case String(kSecAttrProtocolTelnet):
			self = .telnet
		case String(kSecAttrProtocolSSH):
			self = .ssh
		case String(kSecAttrProtocolFTPS):
			self = .ftps
		case String(kSecAttrProtocolHTTPS):
			self = .https
		case String(kSecAttrProtocolHTTPProxy):
			self = .httpProxy
		case String(kSecAttrProtocolHTTPSProxy):
			self = .httpsProxy
		case String(kSecAttrProtocolFTPProxy):
			self = .ftpProxy
		case String(kSecAttrProtocolSMB):
			self = .smb
		case String(kSecAttrProtocolRTSP):
			self = .rtsp
		case String(kSecAttrProtocolRTSPProxy):
			self = .rtspProxy
		case String(kSecAttrProtocolDAAP):
			self = .daap
		case String(kSecAttrProtocolEPPC):
			self = .eppc
		case String(kSecAttrProtocolIPP):
			self = .ipp
		case String(kSecAttrProtocolNNTPS):
			self = .nntps
		case String(kSecAttrProtocolLDAPS):
			self = .ldaps
		case String(kSecAttrProtocolTelnetS):
			self = .telnetS
		case String(kSecAttrProtocolIMAPS):
			self = .imaps
		case String(kSecAttrProtocolIRCS):
			self = .ircs
		case String(kSecAttrProtocolPOP3S):
			self = .pop3S
		default:
			self = .http
		}
	}

	public var rawValue: String {
		switch self {
		case .ftp:
			String(kSecAttrProtocolFTP)
		case .ftpAccount:
			String(kSecAttrProtocolFTPAccount)
		case .http:
			String(kSecAttrProtocolHTTP)
		case .irc:
			String(kSecAttrProtocolIRC)
		case .nntp:
			String(kSecAttrProtocolNNTP)
		case .pop3:
			String(kSecAttrProtocolPOP3)
		case .smtp:
			String(kSecAttrProtocolSMTP)
		case .socks:
			String(kSecAttrProtocolSOCKS)
		case .imap:
			String(kSecAttrProtocolIMAP)
		case .ldap:
			String(kSecAttrProtocolLDAP)
		case .appleTalk:
			String(kSecAttrProtocolAppleTalk)
		case .afp:
			String(kSecAttrProtocolAFP)
		case .telnet:
			String(kSecAttrProtocolTelnet)
		case .ssh:
			String(kSecAttrProtocolSSH)
		case .ftps:
			String(kSecAttrProtocolFTPS)
		case .https:
			String(kSecAttrProtocolHTTPS)
		case .httpProxy:
			String(kSecAttrProtocolHTTPProxy)
		case .httpsProxy:
			String(kSecAttrProtocolHTTPSProxy)
		case .ftpProxy:
			String(kSecAttrProtocolFTPProxy)
		case .smb:
			String(kSecAttrProtocolSMB)
		case .rtsp:
			String(kSecAttrProtocolRTSP)
		case .rtspProxy:
			String(kSecAttrProtocolRTSPProxy)
		case .daap:
			String(kSecAttrProtocolDAAP)
		case .eppc:
			String(kSecAttrProtocolEPPC)
		case .ipp:
			String(kSecAttrProtocolIPP)
		case .nntps:
			String(kSecAttrProtocolNNTPS)
		case .ldaps:
			String(kSecAttrProtocolLDAPS)
		case .telnetS:
			String(kSecAttrProtocolTelnetS)
		case .imaps:
			String(kSecAttrProtocolIMAPS)
		case .ircs:
			String(kSecAttrProtocolIRCS)
		case .pop3S:
			String(kSecAttrProtocolPOP3S)
		}
	}
}
