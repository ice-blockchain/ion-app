// SPDX-License-Identifier: ice License 1.0

import Foundation

struct ReplaceablePrivateDirectMessageData {
    let content: String
    let recipient: String
    let media: [String: MediaItem]
    let relatedPubkeys: [RelatedPubkey]?
    let primaryAudio: MediaItem?
    let quotedEvent: EventReference?
    
    init(
        content: String,
        recipient: String,
        media: [String: MediaItem] = [:],
        relatedPubkeys: [RelatedPubkey]? = nil,
        primaryAudio: MediaItem? = nil,
        quotedEvent: EventReference? = nil
    ) {
        self.content = content
        self.recipient = recipient
        self.media = media
        self.relatedPubkeys = relatedPubkeys
        self.primaryAudio = primaryAudio
        self.quotedEvent = quotedEvent
    }

    static func fromEventMessage(_ eventMessage: EventMessage) -> ReplaceablePrivateDirectMessageData {
        let content = eventMessage.content

        // Get the first p tag for recipient
        var recipient = ""
        for tag in eventMessage.tags {
            if tag.count >= 2 && tag[0] == "p" {
                recipient = tag[1]
                break
            }
        }
        
        // In a real implementation, you would parse media, relatedPubkeys, etc. from tags
        // For now, we'll just create an empty dictionary for media
        let media: [String: MediaItem] = [:]
        
        return ReplaceablePrivateDirectMessageData(
            content: content,
            recipient: recipient,
            media: media
        )
    }
    
    /// Computed property to determine the message type based on content and media
    var messageType: MessageType {
        if primaryAudio != nil {
            return .audio
        } else if IonConnectProtocolIdentifierTypeValidator.isProfileIdentifier(content) {
            return .profile
        } else if content.isEmoji {
            return .emoji
        } else if visualMedias.count > 0 {
            return .visualMedia
        } else if media.count > 0 {
            return .document
        } else if IonConnectProtocolIdentifierTypeValidator.isEventIdentifier(content),
                  let eventReference = EventReferenceFactory.fromEncoded(content) as? ImmutableEventReference {
            switch eventReference.kind {
            case FundsRequestEntity.kind:
                return .requestFunds
            case WalletAssetEntity.kind:
                return .moneySent
            default:
                return .text
            }
        } else if quotedEvent != nil {
            return .sharedPost
        }
        
        return .text
    }
    
    /// Returns media items that are images or videos (visual media)
    var visualMedias: [MediaItem] {
        return media.values.filter { item in
            return item.mediaType == .image || item.mediaType == .video
        }
    }
}

struct ReplaceablePrivateDirectMessageEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Int
    let data: ReplaceablePrivateDirectMessageData

    static let kind = 30014

    init(
        id: String,
        pubkey: String,
        masterPubkey: String,
        signature: String,
        createdAt: Int,
        data: ReplaceablePrivateDirectMessageData
    ) {
        self.id = id
        self.pubkey = pubkey
        self.masterPubkey = masterPubkey
        self.signature = signature
        self.createdAt = createdAt
        self.data = data
    }

    static func fromEventMessage(_ eventMessage: EventMessage) throws -> ReplaceablePrivateDirectMessageEntity {
        if eventMessage.kind != kind {
            throw IncorrectEventKindException(eventMessage.id, kind: kind)
        }

        let masterPubkey = try eventMessage.masterPubkey()

        return ReplaceablePrivateDirectMessageEntity(
            id: eventMessage.id,
            pubkey: eventMessage.pubkey,
            masterPubkey: masterPubkey,
            signature: eventMessage.sig ?? "",
            createdAt: eventMessage.createdAt,
            data: ReplaceablePrivateDirectMessageData.fromEventMessage(eventMessage)
        )
    }
}
