// SPDX-License-Identifier: ice License 1.0

import Foundation

class IonConnectPushDataPayload: Decodable {
    let compression: String?
    let event: EventMessage
    let decryptedEvent: EventMessage?
    let relevantEvents: [EventMessage]
    let decryptedPlaceholders: [String: String]?

    enum CodingKeys: String, CodingKey {
        case compression
        case event
        case relevantEvents = "relevant_events"
    }

    static func fromJson(
        data: [AnyHashable: Any],
        decryptEvent: @escaping (EventMessage) async throws -> (event: EventMessage?, metadata: UserMetadata?)?
    ) async throws -> IonConnectPushDataPayload {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let payload = try JSONDecoder().decode(IonConnectPushDataPayload.self, from: jsonData)

        // Check if we need to decrypt the event
        if payload.event.kind == IonConnectGiftWrapEntity.kind {
            let result = try await decryptEvent(payload.event)
            
            // Create placeholders dictionary from metadata if available
            var placeholders: [String: String]? = nil
            if let metadata = result?.metadata {
                placeholders = [
                    "username": metadata.name,
                    "displayName": metadata.displayName
                ]
            }

            return IonConnectPushDataPayload(
                compression: payload.compression,
                event: payload.event,
                decryptedEvent: result?.event,
                relevantEvents: payload.relevantEvents,
                decryptedPlaceholders: placeholders
            )
        }

        return payload
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        compression = try container.decodeIfPresent(
            String.self,
            forKey: .compression
        )

        let eventString = try container.decode(String.self, forKey: .event)
        let relevantEventsString = try container.decodeIfPresent(String.self, forKey: .relevantEvents) ?? ""

        if let compression = compression, compression == "zlib" {
            do {
                let eventData = try Decompressor.decompress(eventString)
                event = try JSONDecoder().decode(EventMessage.self, from: eventData)

                if !relevantEventsString.isEmpty {
                    let relevantEventsData = try Decompressor.decompress(relevantEventsString)
                    relevantEvents = try JSONDecoder().decode([EventMessage].self, from: relevantEventsData)
                } else {
                    relevantEvents = []
                }
            } catch {
                print("Error decompressing data: \(error)")
                throw error
            }
        } else {
            guard let eventData = eventString.data(using: .utf8) else {
                throw DecompressionError.jsonDataConversionFailed
            }
            event = try JSONDecoder().decode(EventMessage.self, from: eventData)

            if !relevantEventsString.isEmpty,
                let relevantEventsData = relevantEventsString.data(using: .utf8)
            {
                relevantEvents = try JSONDecoder().decode(
                    [EventMessage].self,
                    from: relevantEventsData
                )
            } else {
                relevantEvents = []
            }
        }

        self.decryptedEvent = nil
        self.decryptedPlaceholders = nil
    }

    /// Internal initializer for creating a payload with a decrypted event
    internal init(
        compression: String?,
        event: EventMessage,
        decryptedEvent: EventMessage?,
        relevantEvents: [EventMessage],
        decryptedPlaceholders: [String: String]? = nil
    ) {
        self.compression = compression
        self.event = event
        self.decryptedEvent = decryptedEvent
        self.relevantEvents = relevantEvents
        self.decryptedPlaceholders = decryptedPlaceholders
    }

    var mainEntity: IonConnectEntity? {
        return try? EventParser.parse(event)
    }

    func getNotificationType(currentPubkey: String) -> PushNotificationType? {
        guard let entity = mainEntity else {
            return nil
        }

        if entity is GenericRepostEntity || entity is RepostEntity {
            return .repost
        } else if let modifiablePost = entity as? ModifiablePostEntity,
            modifiablePost.data.quotedEvent != nil
        {
            return .repost
        } else if let post = entity as? PostEntity, post.data.quotedEvent != nil {
            return .repost
        } else if entity is ModifiablePostEntity || entity is PostEntity {
            let currentUserMention = "p:\(currentPubkey)"
            if let post = entity as? ModifiablePostEntity {
                return post.data.textContent.contains(currentUserMention)
                    ? .mention : .reply
            } else if let post = entity as? PostEntity {
                return post.data.textContent.contains(currentUserMention)
                    ? .mention : .reply
            }
        } else if entity is ReactionEntity {
            return .like
        } else if entity is FollowListEntity {
            return .follower
        } else if let entity = entity as? IonConnectGiftWrapEntity {
            if entity.data.kinds.contains(String(ReactionEntity.kind)) {
                return .chatReaction
            } else if entity.data.kinds.contains(String(FundsRequestEntity.kind)) {
                return .paymentRequest
            } else if entity.data.kinds.contains(String(WalletAssetEntity.kind)) {
                return .paymentReceived
            } else if entity.data.kinds.contains(String(ReplaceablePrivateDirectMessageEntity.kind)) {
                // If we don't have a decrypted event, we can't determine the message type
                guard let decryptedEvent = decryptedEvent else { return nil }

                do {
                    let message = try ReplaceablePrivateDirectMessageEntity.fromEventMessage(decryptedEvent)

                    switch message.data.messageType {
                    case .audio:
                        return .chatVoiceMessage
                    case .document:
                        return .chatDocumentMessage
                    case .text:
                        return .chatTextMessage
                    case .emoji:
                        return .chatEmojiMessage
                    case .profile:
                        return .chatProfileMessage
                    case .sharedPost:
                        return .chatSharePostMessage
                    case .requestFunds:
                        return .paymentRequest
                    case .moneySent:
                        return .paymentReceived
                    case .visualMedia:
                        return getVisualMediaNotificationType(message: message)
                    }
                } catch {
                    NSLog("Error parsing decrypted message: \(error)")
                    return nil
                }
            }
        }

        return nil
    }

    var placeholders: [String: String] {
        guard let masterPubkey = try? event.masterPubkey() else {
            return [:]
        }
        
        var data = [String: String]()
        
        // First check if we have decrypted placeholders from database metadata
        if let decryptedPlaceholders = decryptedPlaceholders {
            data.merge(decryptedPlaceholders) { (_, new) in new }
        } else {
            // Fall back to metadata from relevant events if database metadata is not available
            let mainEntityUserMetadata = getUserMetadata(pubkey: masterPubkey)
            if let mainEntityUserMetadata = mainEntityUserMetadata {
                data["username"] = mainEntityUserMetadata.data.name
                data["displayName"] = mainEntityUserMetadata.data.displayName
            }
        }

        if let decryptedEvent = decryptedEvent {
            data["messageContent"] = decryptedEvent.content
            data["reactionContent"] = decryptedEvent.content

            if let entity = try? IonConnectGiftWrapEntity.fromEventMessage(event),
                entity.data.kinds.contains(String(ReplaceablePrivateDirectMessageEntity.kind))
            {

                if let message = try? ReplaceablePrivateDirectMessageEntity.fromEventMessage(decryptedEvent) {
                    data["fileCount"] = String(message.data.media.count)
                }
            }
        }

        return data
    }

    func validate(currentPubkey: String) -> Bool {
        return checkEventsSignatures()
            && checkMainEventRelevant(currentPubkey: currentPubkey)
            && checkRequiredRelevantEvents()
    }

    // MARK: - Private Helper Methods

    private func checkEventsSignatures() -> Bool {
        let mainEventValid = event.validate()
        let relevantEventsValid = relevantEvents.allSatisfy { $0.validate() }

        return mainEventValid && relevantEventsValid
    }

    private func checkMainEventRelevant(currentPubkey: String) -> Bool {
        guard let entity = mainEntity else {
            return false
        }

        if let modifiablePost = entity as? ModifiablePostEntity {
            return modifiablePost.data.relatedPubkeys.contains { pubkey in
                return pubkey.value == currentPubkey
            }
        } else if let post = entity as? PostEntity {
            return post.data.relatedPubkeys.contains { pubkey in
                return pubkey.value == currentPubkey
            }
        } else if let genericRepost = entity as? GenericRepostEntity {
            return genericRepost.data.eventReference.pubkey == currentPubkey
        } else if let repost = entity as? RepostEntity {
            return repost.data.eventReference.pubkey == currentPubkey
        } else if let reaction = entity as? ReactionEntity {
            return reaction.data.eventReference.pubkey == currentPubkey
        } else if let followList = entity as? FollowListEntity {
            return followList.pubkeys.last == currentPubkey
        } else if let giftWrap = entity as? IonConnectGiftWrapEntity {
            return giftWrap.data.relatedPubkeys.contains { pubkey in
                return pubkey.value == currentPubkey
            }
        }

        return false
    }

    private func checkRequiredRelevantEvents() -> Bool {
        if event.kind == IonConnectGiftWrapEntity.kind {
            return true
        } else {
            // For all events except 1059 we need to check if delegation is present
            // in the relevant events and the main event valid for it
            let delegationEvent = relevantEvents.first { event in
                return event.kind == UserDelegationEntity.kind
            }

            guard let delegationEvent = delegationEvent else {
                return false
            }

            do {
                let delegationEntity =
                    try UserDelegationEntity.fromEventMessage(delegationEvent)
                return delegationEntity.data.validate(event)
            } catch {
                print("Error parsing delegation entity: \(error)")
                return false
            }
        }
    }

    /// Determines the notification type for visual media messages based on media content
    /// - Parameter message: The private direct message entity containing visual media
    /// - Returns: The appropriate push notification type based on media content
    private func getVisualMediaNotificationType(message: ReplaceablePrivateDirectMessageEntity) -> PushNotificationType {
        let mediaItems = Array(message.data.media.values)

        // Check if all media items are images
        let allImages = mediaItems.allSatisfy { media in
            return media.mediaType == .image
        }

        if allImages {
            // Check if all are GIFs
            let allGifs = mediaItems.allSatisfy { media in
                return media.url.isGif
            }

            if mediaItems.count == 1 {
                return allGifs ? .chatGifMessage : .chatPhotoMessage
            } else {
                return allGifs ? .chatMultiGifMessage : .chatMultiPhotoMessage
            }
        } else if mediaItems.contains(where: { $0.mediaType == .video }) {
            // Count video items and thumbnails
            let videoItems = mediaItems.filter { $0.mediaType == .video }
            let thumbItems = mediaItems.filter { $0.thumb != nil }

            if videoItems.count == 1 && thumbItems.count == 1 {
                return .chatVideoMessage
            } else if videoItems.count == thumbItems.count {
                return .chatMultiVideoMessage
            } else {
                return .chatMultiMediaMessage
            }
        }

        return .chatMultiMediaMessage
    }

    private func getUserMetadata(pubkey: String) -> UserMetadataEntity? {
        let delegationEvent = relevantEvents.first { event in
            return event.kind == UserDelegationEntity.kind
                && event.pubkey == pubkey
        }

        guard let delegationEvent = delegationEvent else { return nil }

        let delegationEntity = try! UserDelegationEntity.fromEventMessage(
            delegationEvent
        )

        for event in relevantEvents {
            if event.kind == UserMetadataEntity.kind
                && delegationEntity.data.validate(event)
            {
                do {
                    let userMetadataEntity =
                        try UserMetadataEntity.fromEventMessage(event)
                    if userMetadataEntity.masterPubkey
                        == delegationEntity.pubkey
                    {
                        return userMetadataEntity
                    }
                } catch {
                    continue
                }
            }
        }

        return nil
    }
}

enum PushNotificationType: String, Decodable {
    case reply
    case mention
    case repost
    case like
    case follower
    case paymentRequest
    case paymentReceived
    case chatDocumentMessage
    case chatEmojiMessage
    case chatPhotoMessage
    case chatProfileMessage
    case chatReaction
    case chatSharePostMessage
    case chatShareStoryMessage
    case chatSharedStoryReplyMessage
    case chatTextMessage
    case chatVideoMessage
    case chatVoiceMessage
    case chatFirstContactMessage
    case chatGifMessage
    case chatMultiGifMessage
    case chatMultiMediaMessage
    case chatMultiPhotoMessage
    case chatMultiVideoMessage
}

// MARK: - Helper Extensions

extension String {
    /// Determines if a URL string points to a GIF image
    var isGif: Bool {
        let lowercased = self.lowercased()
        return lowercased.hasSuffix(".gif") || lowercased.contains("gif")
    }
}
