// SPDX-License-Identifier: ice License 1.0

import Foundation

class IonConnectPushDataPayload: Decodable {
    let compression: String?
    let event: EventMessage
    let relevantEvents: [EventMessage]

    enum CodingKeys: String, CodingKey {
        case compression
        case event
        case relevantEvents = "relevant_events"
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
               let relevantEventsData = relevantEventsString.data(using: .utf8) {
                relevantEvents = try JSONDecoder().decode(
                    [EventMessage].self,
                    from: relevantEventsData
                )
            } else {
                relevantEvents = []
            }
        }
        
        if (event.kind == IonConnectGiftWrapEntity.kind) {
            
        }
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
            if entity.data.kinds.contains(
                String(ReplaceablePrivateDirectMessageEntity.kind)
            ) {
                return .chatMessage
            } else if entity.data.kinds.contains(String(ReactionEntity.kind)) {
                return .chatReaction
            } else if entity.data.kinds.contains(
                String(FundsRequestEntity.kind)
            ) {
                return .paymentRequest
            } else if entity.data.kinds.contains(String(WalletAssetEntity.kind)) {
                return .paymentReceived
            }
        }

        return nil
    }

    var placeholders: [String: String] {
        guard let masterPubkey = try? event.masterPubkey() else {
            return [:]
        }

        let mainEntityUserMetadata = getUserMetadata(
            pubkey: masterPubkey
        )

        if let mainEntityUserMetadata = mainEntityUserMetadata {
            return [
                "username": mainEntityUserMetadata.data.displayName.isEmpty
                    ? mainEntityUserMetadata.data.name
                    : mainEntityUserMetadata.data.displayName
            ]
        }

        return [:]
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
    case chatMessage
    case chatReaction
    case paymentRequest
    case paymentReceived
}
