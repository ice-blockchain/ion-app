// SPDX-License-Identifier: ice License 1.0

import Foundation

struct RelatedPubkey {
    let value: String
    let relationType: String?

    init(value: String, relationType: String? = nil) {
        self.value = value
        self.relationType = relationType
    }

    static func fromTag(_ tag: [String]) -> RelatedPubkey? {
        guard tag.count >= 2, tag[0] == "p" else { return nil }

        let value = tag[1]
        let relationType = tag.count >= 3 ? tag[2] : nil

        return RelatedPubkey(value: value, relationType: relationType)
    }
}
