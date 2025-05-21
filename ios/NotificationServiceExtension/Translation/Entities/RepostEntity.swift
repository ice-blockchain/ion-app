// SPDX-License-Identifier: ice License 1.0

import Foundation

struct RepostData {
    let eventReference: EventReference

    static func fromEventMessage(_ eventMessage: EventMessage) -> RepostData {
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

        return RepostData(
            eventReference: eventRef ?? ImmutableEventReference(id: "", pubkey: "")
        )
    }
}

struct RepostEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Date
    let data: RepostData

    static let kind = 6

    init(id: String, pubkey: String, masterPubkey: String, signature: String, createdAt: Date, data: RepostData) {
        self.id = id
        self.pubkey = pubkey
        self.masterPubkey = masterPubkey
        self.signature = signature
        self.createdAt = createdAt
        self.data = data
    }

    static func fromEventMessage(_ eventMessage: EventMessage) throws -> RepostEntity {
        if eventMessage.kind != kind {
            throw IncorrectEventKindException(eventMessage.id, kind: kind)
        }

        let masterPubkey = try eventMessage.masterPubkey()

        return RepostEntity(
            id: eventMessage.id,
            pubkey: eventMessage.pubkey,
            masterPubkey: masterPubkey,
            signature: eventMessage.sig ?? "",
            createdAt: eventMessage.createdAt,
            data: RepostData.fromEventMessage(eventMessage)
        )
    }
}
