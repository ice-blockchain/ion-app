// SPDX-License-Identifier: ice License 1.0

import Foundation

struct FundsRequestData {
    let amount: String
    let recipient: String

    static func fromEventMessage(_ eventMessage: EventMessage) -> FundsRequestData {
        let content = eventMessage.content

        // Get the first p tag for recipient
        var recipient = ""
        for tag in eventMessage.tags {
            if tag.count >= 2 && tag[0] == "p" {
                recipient = tag[1]
                break
            }
        }

        return FundsRequestData(
            amount: content,
            recipient: recipient
        )
    }
}

struct FundsRequestEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Date
    let data: FundsRequestData

    static let kind = 1755

    init(id: String, pubkey: String, masterPubkey: String, signature: String, createdAt: Date, data: FundsRequestData) {
        self.id = id
        self.pubkey = pubkey
        self.masterPubkey = masterPubkey
        self.signature = signature
        self.createdAt = createdAt
        self.data = data
    }

    static func fromEventMessage(_ eventMessage: EventMessage) throws -> FundsRequestEntity {
        if eventMessage.kind != kind {
            throw IncorrectEventKindException(eventMessage.id, kind: kind)
        }

        let masterPubkey = try eventMessage.masterPubkey()

        return FundsRequestEntity(
            id: eventMessage.id,
            pubkey: eventMessage.pubkey,
            masterPubkey: masterPubkey,
            signature: eventMessage.sig ?? "",
            createdAt: eventMessage.createdAt,
            data: FundsRequestData.fromEventMessage(eventMessage)
        )
    }
}
