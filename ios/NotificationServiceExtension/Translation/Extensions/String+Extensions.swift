// SPDX-License-Identifier: ice License 1.0

import Foundation

extension String {
    /// Determines if the string consists only of emoji characters
    var isEmoji: Bool {
        // Simple check: if the string is not empty and contains only emoji characters
        guard !isEmpty else { return false }
        
        // Check if all characters are emoji
        // This is a simplified implementation - a more robust one would use Unicode properties
        return unicodeScalars.allSatisfy { scalar in
            scalar.properties.isEmoji && !scalar.properties.isWhitespace
        }
    }
}
