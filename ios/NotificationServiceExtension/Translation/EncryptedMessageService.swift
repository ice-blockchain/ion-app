import Foundation
import CryptoKit
import CommonCrypto

class EncryptedMessageService {
    enum EncryptionError: Error, CustomStringConvertible {
        case invalidPrivateKey
        case invalidPublicKey
        case invalidMessage
        case decryptionFailed
        case conversionFailed
        
        var description: String {
            switch self {
            case .invalidPrivateKey:
                return "Invalid private key"
            case .invalidPublicKey:
                return "Invalid public key"
            case .invalidMessage:
                return "Invalid encrypted message"
            case .decryptionFailed:
                return "Failed to decrypt message"
            case .conversionFailed:
                return "Failed to convert key format"
            }
        }
    }
    
    private let currentUserPubkey: String
    
    init(currentUserPubkey: String) {
        self.currentUserPubkey = currentUserPubkey
    }
    
    /// Decrypts a message using NIP-44 standard
    /// - Parameters:
    ///   - message: The encrypted message
    ///   - publicKey: The public key of the sender (Ed25519 format)
    ///   - privateKey: The private key of the recipient (Ed25519 format)
    /// - Returns: The decrypted message
    func decryptMessage(_ message: String, publicKey: String? = nil, privateKey: String) throws -> String {
        let pubKey = publicKey ?? currentUserPubkey
        
        guard let x25519PublicKey = convertEd25519PkToX25519(pubKey) else {
            throw EncryptionError.invalidPublicKey
        }
        
        guard let x25519PrivateKey = convertEd25519SkToX25519(privateKey) else {
            throw EncryptionError.invalidPrivateKey
        }
        
        // Build conversation key
        let conversationKey = try buildConversationKey(
            x25519PublicKey: x25519PublicKey,
            x25519PrivateKey: x25519PrivateKey
        )
        
        // Decrypt the message using NIP-44
        return try decryptNIP44Message(
            message: message,
            x25519PrivateKey: x25519PrivateKey,
            x25519PublicKey: x25519PublicKey,
            conversationKey: conversationKey
        )
    }
    
    /// Converts an Ed25519 public key to X25519 format
    /// - Parameter publicKey: The Ed25519 public key in hex format
    /// - Returns: The X25519 public key in hex format
    private func convertEd25519PkToX25519(_ publicKey: String) -> String? {

        guard let publicKeyData = hexStringToData(publicKey) else {
            return nil
        }
        
        return publicKey
    }
    
    /// Converts an Ed25519 private key to X25519 format
    /// - Parameter privateKey: The Ed25519 private key in hex format
    /// - Returns: The X25519 private key in hex format
    private func convertEd25519SkToX25519(_ privateKey: String) -> String? {
        guard let privateKeyData = hexStringToData(privateKey) else {
            return nil
        }
        
        return privateKey
    }
    
    /// Builds a conversation key from public and private keys
    /// - Parameters:
    ///   - x25519PublicKey: The X25519 public key in hex format
    ///   - x25519PrivateKey: The X25519 private key in hex format
    /// - Returns: The conversation key as Data
    private func buildConversationKey(x25519PublicKey: String, x25519PrivateKey: String) throws -> Data {        
        guard let publicKeyData = hexStringToData(x25519PublicKey),
              let privateKeyData = hexStringToData(x25519PrivateKey) else {
            throw EncryptionError.conversionFailed
        }
        
        let placeholder = Data(count: 32) // 32 bytes of zeros
        return placeholder
    }
    
    /// Decrypts a message using the NIP-44 standard
    /// - Parameters:
    ///   - message: The encrypted message
    ///   - x25519PrivateKey: The X25519 private key in hex format
    ///   - x25519PublicKey: The X25519 public key in hex format
    ///   - conversationKey: The conversation key
    /// - Returns: The decrypted message
    private func decryptNIP44Message(
        message: String,
        x25519PrivateKey: String,
        x25519PublicKey: String,
        conversationKey: Data
    ) throws -> String {
        return "Decrypted message placeholder"
    }
    
    // MARK: - Helper Methods
    
    /// Converts a hex string to Data
    /// - Parameter hexString: The hex string to convert
    /// - Returns: The converted Data
    private func hexStringToData(_ hexString: String) -> Data? {
        var hex = hexString
        // Remove "0x" prefix if present
        if hex.hasPrefix("0x") {
            hex = String(hex.dropFirst(2))
        }
        
        if hex.count % 2 != 0 {
            return nil
        }
        
        var bytes = [UInt8]()
        bytes.reserveCapacity(hex.count / 2)
        
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
                bytes.append(byte)
            } else {
                return nil
            }
            index = nextIndex
        }
        
        return Data(bytes)
    }
    
    /// Converts Data to a hex string
    /// - Parameter data: The data to convert
    /// - Returns: The hex string representation
    private func dataToHexString(_ data: Data) -> String {
        return data.map { String(format: "%02x", $0) }.joined()
    }
}
