// SPDX-License-Identifier: ice License 1.0

import Foundation
import Security

class KeychainService {
    private static let keychainGroupKey = "KEYCHAIN_GROUP"

    enum KeychainError: Error {
        case noAppGroupIdentifier
        case noKeychainGroupIdentifier
        case keychainAccessFailed(OSStatus)
        case dataConversionFailed
        case invalidData
    }

    private let currentIdentityKeyName: String
    private var privateKey: String?

    init(
        currentIdentityKeyName: String,
    ) {
        self.currentIdentityKeyName = currentIdentityKeyName

        do {
            _ = try self.getPrivateKey()
            self.log("Successfully preloaded private key")
        } catch {
            self.log("Failed to preload private key: \(error)")
        }

    }

    /// Retrieves the private key from the keychain or from cache if available
    /// - Returns: The private key as a string
    /// - Throws: KeychainError if the key cannot be retrieved
    func getPrivateKey() throws -> String? {
        // Check if we need to refresh the key (identity changed or first load)

        if let privateKey = self.privateKey {
            log("Using cached private key for identity: \(currentIdentityKeyName)")
            return privateKey
        }

        log("Fetching private key from keychain for identity: \(currentIdentityKeyName)")
        return try fetchPrivateKeyFromKeychain(for: currentIdentityKeyName)
    }

    /// Fetches the private key from the keychain for a specific identity
    /// - Parameter identityKeyName: The identity key name to fetch the private key for
    /// - Returns: The private key as a string
    /// - Throws: KeychainError if the key cannot be retrieved from the keychain
    private func fetchPrivateKeyFromKeychain(for identityKeyName: String) throws -> String? {
        let storageKey = "\(identityKeyName)_nostr_key_store"
        log("Storage key: \(storageKey)")

        guard
            let keychainGroupIdentifier = Bundle.main.object(forInfoDictionaryKey: KeychainService.keychainGroupKey) as? String
        else {
            throw KeychainError.noKeychainGroupIdentifier
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: storageKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessGroup as String: keychainGroupIdentifier,
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status != errSecSuccess {
            log("Keychain access failed with status: \(status)")
            throw KeychainError.keychainAccessFailed(status)
        }

        guard let data = item as? Data else {
            log("Failed to convert keychain item to data")
            throw KeychainError.dataConversionFailed
        }

        guard let privateKeyString = String(data: data, encoding: .utf8) else {
            log("Failed to convert data to string")
            throw KeychainError.dataConversionFailed
        }

        // Cache the private key
        self.privateKey = privateKeyString
        log("Successfully retrieved private key (length: \(privateKeyString.count))")

        return privateKeyString
    }

    private func log(_ message: String) {
        print("[KeychainService] \(message)")
    }
}
