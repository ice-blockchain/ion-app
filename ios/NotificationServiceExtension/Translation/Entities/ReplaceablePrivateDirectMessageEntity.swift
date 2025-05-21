// SPDX-License-Identifier: ice License 1.0

import Foundation

struct ReplaceablePrivateDirectMessageData {
    let content: String
    let recipient: String

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

        return ReplaceablePrivateDirectMessageData(
            content: content,
            recipient: recipient
        )
    }
}

struct ReplaceablePrivateDirectMessageEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Date
    let data: ReplaceablePrivateDirectMessageData

    static let kind = 30014

    init(
        id: String,
        pubkey: String,
        masterPubkey: String,
        signature: String,
        createdAt: Date,
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
