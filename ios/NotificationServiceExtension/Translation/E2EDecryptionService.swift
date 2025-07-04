// SPDX-License-Identifier: ice License 1.0

import Clibsodium
import CryptoKit
import Foundation
import NostrSDK
import Sodium

class E2EDecryptionService: NIP44v2Encrypting {
    enum DecryptionError: Error {
        case invalidPrivateKey
        case keyConversionFailed
        case sharedSecretFailed
        case jsonDecodingFailed
    }

    private let keychainService: KeychainService
    private let pubkey: String

    init(keychainService: KeychainService, pubkey: String) {
        self.keychainService = keychainService
        self.pubkey = pubkey
    }

    /// Decrypts an E2E encrypted message using the private key from keychain
    /// - Parameter eventMessage: The encrypted event message to decrypt
    /// - Returns: The decrypted event message
    func decryptMessage(_ eventMessage: EventMessage) async throws -> EventMessage? {
        guard let privateKeyString = try keychainService.getPrivateKey() else {
            throw DecryptionError.invalidPrivateKey
        }

        let content = eventMessage.content
        let senderPubkey = eventMessage.pubkey

        // Convert keys from Ed25519 to X25519 format
        guard let x25519PrivateKey = convertEd25519SkToX25519(privateKeyString),
            let x25519PublicKey = convertEd25519PkToX25519(senderPubkey),
            let privateKey = PrivateKey(hex: x25519PrivateKey),
            let publicKey = PublicKey(hex: x25519PublicKey)
        else {
            NSLog("Failed to convert keys from Ed25519 to X25519")
            throw DecryptionError.keyConversionFailed
        }

        do {
            let customConversationKey = getX25519SharedSecret(privateKey: privateKey, publicKey: publicKey)
            let decryptedContent = try decrypt(payload: content, privateKeyA: privateKey, publicKeyB: publicKey, customConversationKey: customConversationKey)

            guard let data = decryptedContent.data(using: .utf8) else { return nil }

            return try? JSONDecoder().decode(EventMessage.self, from: data)
        } catch {
            NSLog("Error decrypting message: \(error)")
            return nil
        }
    }

    /// Converts Ed25519 public key to X25519 public key
    private func convertEd25519PkToX25519(_ publicKey: String) -> String? {
        var curve25519Bytes = [UInt8](repeating: 0, count: crypto_box_publickeybytes())

        if 0 == crypto_sign_ed25519_pk_to_curve25519(&curve25519Bytes, [UInt8](hex: publicKey)) {
            let pk = Box.PublicKey(curve25519Bytes).toHexString()
            return pk
        } else {
            return nil
        }
    }

    /// Converts Ed25519 private key to X25519 private key
    private func convertEd25519SkToX25519(_ privateKey: String) -> String? {
        var curve25519Bytes = [UInt8](repeating: 0, count: crypto_box_secretkeybytes())

        if 0 == crypto_sign_ed25519_sk_to_curve25519(&curve25519Bytes, [UInt8](hex: privateKey)) {
            let x25519PrivateKeyHex = Box.SecretKey(curve25519Bytes).toHexString()
            return x25519PrivateKeyHex
        } else {
            return nil
        }
    }

    /// Generates a shared secret using X25519 key exchange with CryptoKit
    /// - Parameters:
    ///   - privateKey: The private key
    ///   - publicKey: The public key
    /// - Returns: The shared secret as bytes, or nil if the operation fails
    func getX25519SharedSecret(privateKey: PrivateKey, publicKey: PublicKey) -> [UInt8]? {
        do {
            let privateKeyData = privateKey.dataRepresentation
            let publicKeyData = publicKey.dataRepresentation
            guard let cryptoKitPrivateKey = try? Curve25519.KeyAgreement.PrivateKey(rawRepresentation: privateKeyData) else {
                NSLog("Failed to create CryptoKit private key")
                return nil
            }
            
            guard let cryptoKitPublicKey = try? Curve25519.KeyAgreement.PublicKey(rawRepresentation: publicKeyData) else {
                NSLog("Failed to create CryptoKit public key")
                return nil
            }
            
            let sharedSecret = try cryptoKitPrivateKey.sharedSecretFromKeyAgreement(with: cryptoKitPublicKey)
            
            let sharedSecretData = sharedSecret.withUnsafeBytes { bytes in
                return Data(bytes)
            }
            
            return [UInt8](sharedSecretData)
        } catch {
            NSLog("Error generating shared secret: \(error)")
            return nil
        }
    }
}
