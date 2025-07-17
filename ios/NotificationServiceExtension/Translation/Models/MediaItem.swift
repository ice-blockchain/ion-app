// SPDX-License-Identifier: ice License 1.0

import Foundation

struct MediaItem: Codable {
    let url: String
    let mediaType: MediaType
    let thumb: String?
    
    init(url: String, mediaType: MediaType, thumb: String? = nil) {
        self.url = url
        self.mediaType = mediaType
        self.thumb = thumb
    }
}
