// SPDX-License-Identifier: ice License 1.0

import Foundation

struct WalletAssetData {
    let amount: String
    let recipient: String

    static func fromEventMessage(_ eventMessage: EventMessage) -> WalletAssetData {
        let content = eventMessage.content

        // Get the first p tag for recipient
        var recipient = ""
        for tag in eventMessage.tags {
            if tag.count >= 2 && tag[0] == "p" {
                recipient = tag[1]
                break
            }
        }

        return WalletAssetData(
            amount: content,
            recipient: recipient
        )
    }
}

struct WalletAssetEntity: IonConnectEntity {
    let id: String
    let pubkey: String
    let masterPubkey: String
    let signature: String
    let createdAt: Int
    let data: WalletAssetData

    static let kind = 1756

    init(id: String, pubkey: String, masterPubkey: String, signature: String, createdAt: Int, data: WalletAssetData) {
        self.id = id
        self.pubkey = pubkey
        self.masterPubkey = masterPubkey
        self.signature = signature
        self.createdAt = createdAt
        self.data = data
    }

    static func fromEventMessage(_ eventMessage: EventMessage) throws -> WalletAssetEntity {
        if eventMessage.kind != kind {
            throw IncorrectEventKindException(eventMessage.id, kind: kind)
        }

        let masterPubkey = try eventMessage.masterPubkey()

        return WalletAssetEntity(
            id: eventMessage.id,
            pubkey: eventMessage.pubkey,
            masterPubkey: masterPubkey,
            signature: eventMessage.sig ?? "",
            createdAt: eventMessage.createdAt,
            data: WalletAssetData.fromEventMessage(eventMessage)
        )
    }
}
