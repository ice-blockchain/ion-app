// SPDX-License-Identifier: ice License 1.0

import Foundation

struct ReactionData {
    let content: String
    let eventReference: EventReference

    static func fromEventMessage(_ eventMessage: EventMessage) -> ReactionData {
        let content = eventMessage.content

        // Get the first e tag for event reference
        var eventRef: EventReference?
        for tag in eventMessage.tags {
            if tag.count >= 4 && tag[0] == "e" {
                let id = tag[1]
                let kindStr = tag[2]
                let pubkey = tag[3]

                if let kind = Int(kindStr) {
                    eventRef = ImmutableEventReference(id: id, pubkey: pubkey)
                    break
                }
            }
        }

        return ReactionData(
            content: content,
            eventReference: eventRef ?? ImmutableEventReference(id: "", pubkey: "")
        )
    }
}

struct ReactionEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Date
    let data: ReactionData

    static let kind = 7

    init(id: String, pubkey: String, masterPubkey: String, signature: String, createdAt: Date, data: ReactionData) {
        self.id = id
        self.pubkey = pubkey
        self.masterPubkey = masterPubkey
        self.signature = signature
        self.createdAt = createdAt
        self.data = data
    }

    static func fromEventMessage(_ eventMessage: EventMessage) throws -> ReactionEntity {
        if eventMessage.kind != kind {
            throw IncorrectEventKindException(eventMessage.id, kind: kind)
        }

        let masterPubkey = try eventMessage.masterPubkey()

        return ReactionEntity(
            id: eventMessage.id,
            pubkey: eventMessage.pubkey,
            masterPubkey: masterPubkey,
            signature: eventMessage.sig ?? "",
            createdAt: eventMessage.createdAt,
            data: ReactionData.fromEventMessage(eventMessage)
        )
    }
}
