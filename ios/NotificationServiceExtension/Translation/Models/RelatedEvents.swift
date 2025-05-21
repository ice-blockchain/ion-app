// SPDX-License-Identifier: ice License 1.0

import Foundation

struct RelatedEvent {
    let id: String
    let kind: Int
    let pubkey: String

    init(id: String, kind: Int, pubkey: String) {
        self.id = id
        self.kind = kind
        self.pubkey = pubkey
    }

    static func fromTag(_ tag: [String]) -> RelatedEvent? {
        guard tag.count >= 4, tag[0] == "e" else { return nil }

        let id = tag[1]
        let kindStr = tag[2]
        let pubkey = tag[3]

        guard let kind = Int(kindStr) else { return nil }

        return RelatedEvent(id: id, kind: kind, pubkey: pubkey)
    }
}
