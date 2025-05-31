// SPDX-License-Identifier: ice License 1.0

import Foundation

struct GenericRepostData {
    let eventReference: EventReference

    static func fromEventMessage(_ eventMessage: EventMessage) -> GenericRepostData {
        // Get the first e tag for event reference
        var eventRef: EventReference?
        for tag in eventMessage.tags {
            if tag.count >= 4 && tag[0] == "e" {
                let id = tag[1]
                let kindStr = tag[2]
                let pubkey = tag[3]

                if let _ = Int(kindStr) {
                    eventRef = ImmutableEventReference(id: id, pubkey: pubkey)
                    break
                }
            }
        }

        return GenericRepostData(
            eventReference: eventRef ?? ImmutableEventReference(id: "", pubkey: "")
        )
    }
}

struct GenericRepostEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Int
    let data: GenericRepostData

    static let kind = 16

    init(id: String, pubkey: String, masterPubkey: String, signature: String, createdAt: Int, data: GenericRepostData) {
        self.id = id
        self.pubkey = pubkey
        self.masterPubkey = masterPubkey
        self.signature = signature
        self.createdAt = createdAt
        self.data = data
    }

    static func fromEventMessage(_ eventMessage: EventMessage) throws -> GenericRepostEntity {
        if eventMessage.kind != kind {
            throw IncorrectEventKindException(eventMessage.id, kind: kind)
        }

        let masterPubkey = try eventMessage.masterPubkey()

        return GenericRepostEntity(
            id: eventMessage.id,
            pubkey: eventMessage.pubkey,
            masterPubkey: masterPubkey,
            signature: eventMessage.sig ?? "",
            createdAt: eventMessage.createdAt,
            data: GenericRepostData.fromEventMessage(eventMessage)
        )
    }
}
