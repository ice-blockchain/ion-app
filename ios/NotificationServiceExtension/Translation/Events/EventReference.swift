// SPDX-License-Identifier: ice License 1.0

import Foundation

protocol EventReference {
    var pubkey: String { get }
    func toString() -> String
}

struct ReplaceableEventReference: EventReference {
    let pubkey: String
    let kind: Int

    init(pubkey: String, kind: Int) {
        self.pubkey = pubkey
        self.kind = kind
    }

    static func fromString(_ string: String) -> ReplaceableEventReference {
        let components = string.split(separator: ":")
        guard components.count >= 2,
            let kind = Int(components[1])
        else {
            // Default fallback if parsing fails
            return ReplaceableEventReference(pubkey: "", kind: 0)
        }

        return ReplaceableEventReference(
            pubkey: String(components[0]),
            kind: kind
        )
    }

    func toString() -> String {
        return "\(pubkey):\(kind)"
    }

    func encode() -> String {
        return toString()
    }
}

struct ImmutableEventReference: EventReference {
    let id: String
    let pubkey: String

    init(id: String, pubkey: String) {
        self.id = id
        self.pubkey = pubkey
    }

    static func fromString(_ string: String) -> ImmutableEventReference {
        // For immutable events, the string is just the event ID
        // The pubkey should be provided separately
        return ImmutableEventReference(id: string, pubkey: "")
    }

    func toString() -> String {
        return id
    }
}
