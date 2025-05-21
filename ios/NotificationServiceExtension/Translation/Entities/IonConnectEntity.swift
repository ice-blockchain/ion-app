// SPDX-License-Identifier: ice License 1.0

import Foundation

protocol IonConnectEntity {
    var id: String { get }
    var pubkey: String { get }
    var masterPubkey: String { get }
    var signature: String { get }
    var createdAt: Date { get }
}

extension IonConnectEntity {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
