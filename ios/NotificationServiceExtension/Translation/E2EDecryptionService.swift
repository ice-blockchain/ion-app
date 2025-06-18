import Foundation

class E2EDecryptionService {
    enum DecryptionError: Error, CustomStringConvertible {
        case invalidPrivateKey
        case decryptionFailed
        case invalidSealContent
        case invalidSignature
        case delegationVerificationFailed
        case noPubkeyAvailable
        case jsonParsingFailed
        
        var description: String {
            switch self {
            case .invalidPrivateKey:
                return "Invalid private key"
            case .decryptionFailed:
                return "Failed to decrypt message"
            case .invalidSealContent:
                return "Invalid seal content"
            case .invalidSignature:
                return "Invalid signature"
            case .delegationVerificationFailed:
                return "Failed to verify delegation"
            case .noPubkeyAvailable:
                return "No public key available"
            case .jsonParsingFailed:
                return "Failed to parse JSON content"
            }
        }
    }
    
    private let keychainService: KeychainService
    private var encryptedMessageService: EncryptedMessageService?
    private let getCurrentPubkey: () -> String?
    
    init(keychainService: KeychainService, getCurrentPubkey: @escaping () -> String?) {
        self.keychainService = keychainService
        self.getCurrentPubkey = getCurrentPubkey
    }
    
    /// Decrypts an E2E encrypted message using the private key from keychain
    /// - Parameter eventMessage: The encrypted event message to decrypt
    /// - Returns: The decrypted event message
    func decryptMessage(_ eventMessage: EventMessage) async throws -> EventMessage {
        guard let privateKey = try keychainService.getPrivateKey() else {
            throw DecryptionError.invalidPrivateKey
        }
        
        guard let currentPubkey = getCurrentPubkey() else {
            throw DecryptionError.noPubkeyAvailable
        }
        
        let messageService = EncryptedMessageService(currentUserPubkey: currentPubkey)
        
        guard eventMessage.kind == IonConnectGiftWrapEntity.kind else {
            return eventMessage
        }
        
        let content = eventMessage.content
            
        do {
            let decryptedContent = try messageService.decryptMessage(
                content,
                publicKey: eventMessage.pubkey,
                privateKey: privateKey
            )
            
            guard let jsonData = decryptedContent.data(using: .utf8),
                  let decryptedMessage = try? JSONDecoder().decode(EventMessage.self, from: jsonData) else {
                throw DecryptionError.jsonParsingFailed
            }
            
            print("Successfully decrypted E2E message with ID: \(eventMessage.id)")
            return decryptedMessage
            
        } catch {
            print("Failed to decrypt message: \(error)")
            throw DecryptionError.decryptionFailed
        }
    }
}
