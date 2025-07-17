// SPDX-License-Identifier: ice License 1.0

import Foundation

struct ShareableIdentifier {
    let prefix: String
    let data: [String: String]
    
    init(prefix: String, data: [String: String]) {
        self.prefix = prefix
        self.data = data
    }
}
