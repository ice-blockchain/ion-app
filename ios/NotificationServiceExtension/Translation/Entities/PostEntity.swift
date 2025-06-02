// SPDX-License-Identifier: ice License 1.0

import Foundation

class PostEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Int
    let data: PostData

    static let kind = 1

    init(id: String, pubkey: String, masterPubkey: String, signature: String, createdAt: Int, data: PostData) {
        self.id = id
        self.pubkey = pubkey
        self.masterPubkey = masterPubkey
        self.signature = signature
        self.createdAt = createdAt
        self.data = data
    }

    static func fromEventMessage(_ eventMessage: EventMessage) throws -> PostEntity {
        if eventMessage.kind != kind {
            throw IncorrectEventKindException(eventMessage.id, kind: kind)
        }

        let masterPubkey = try eventMessage.masterPubkey()

        return PostEntity(
            id: eventMessage.id,
            pubkey: eventMessage.pubkey,
            masterPubkey: masterPubkey,
            signature: eventMessage.sig ?? "",
            createdAt: eventMessage.createdAt,
            data: PostData.fromEventMessage(eventMessage)
        )
    }
}

struct PostData {
    let textContent: String
    let relatedEvents: [RelatedEvent]
    let relatedPubkeys: [RelatedPubkey]
    let quotedEvent: QuotedEvent?

    static func fromEventMessage(_ eventMessage: EventMessage) -> PostData {
        let textContent = eventMessage.content

        // Parse related events from e tags
        var relatedEvents: [RelatedEvent] = []
        for tag in eventMessage.tags {
            if tag.count >= 4 && tag[0] == "e" {
                if let relatedEvent = RelatedEvent.fromTag(tag) {
                    relatedEvents.append(relatedEvent)
                }
            }
        }

        // Parse related pubkeys from p tags
        var relatedPubkeys: [RelatedPubkey] = []
        for tag in eventMessage.tags {
            if tag.count >= 2 && tag[0] == "p" {
                if let relatedPubkey = RelatedPubkey.fromTag(tag) {
                    relatedPubkeys.append(relatedPubkey)
                }
            }
        }

        // Parse quoted event from q or Q tags
        var quotedEvent: QuotedEvent? = nil
        for tag in eventMessage.tags {
            if tag.count >= 4 && (tag[0] == "q" || tag[0] == "Q") {
                do {
                    quotedEvent = try QuotedEventFactory.fromTag(tag)
                    break
                } catch {
                    print("Error parsing quoted event: \(error)")
                }
            }
        }

        return PostData(
            textContent: textContent,
            relatedEvents: relatedEvents,
            relatedPubkeys: relatedPubkeys,
            quotedEvent: quotedEvent
        )
    }
}
