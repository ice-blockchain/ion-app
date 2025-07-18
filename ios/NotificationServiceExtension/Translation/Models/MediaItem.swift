// SPDX-License-Identifier: ice License 1.0

import Foundation

struct MediaItem: Codable {
    let url: String
    let mimeType: String
    let mediaType: MediaType
    let thumb: String?
    let mediaExt: String?

    init(
        url: String,
        mimeType: String,
        dimension: String? = nil,
        thumb: String? = nil,
        mediaExt: String? = nil
    ) {
        self.url = url
        self.mimeType = mimeType
        self.mediaType = MediaType.fromMimeType(mimeType)
        self.thumb = thumb
        self.mediaExt = mediaExt
    }

    /// Parse a single imeta tag into a MediaItem
    /// Format: ["imeta", "url URL", "m MIMETYPE", "dim DIMENSION", ...]
    static func fromTag(_ tag: [String]) -> MediaItem? {
        if tag.count < 3 || tag[0] != "imeta" {
            return nil
        }

        var url: String? = nil
        var mimeType: String? = nil
        var thumb: String? = nil

        // Skip the first element ("imeta") and parse the rest
        for param in tag.dropFirst() {
            let components = param.split(separator: " ", maxSplits: 1)
            if components.count < 2 {
                continue
            }

            let key = String(components[0])
            let value = String(components[1])

            switch key {
            case "url":
                url = value
            case "m":
                mimeType = value
            case "thumb":
                thumb = value
            default:
                break
            }
        }

        // URL and MIME type are required
        guard let url = url, let mimeType = mimeType else {
            return nil
        }

        return MediaItem(
            url: url,
            mimeType: mimeType,
            thumb: thumb,
            mediaExt: mimeType.split(separator: "/").last?.lowercased()
        )
    }

    /// Parse multiple imeta tags into a dictionary of MediaItems
    static func parseImeta(_ tags: [[String]]?) -> [MediaItem] {
        guard let tags = tags else {
            return []
        }

        var mediaItems = [MediaItem]()

        for tag in tags {
            if tag.count >= 3 && tag[0] == "imeta" {
                if let mediaItem = MediaItem.fromTag(tag) {
                    mediaItems.append(mediaItem)
                }
            }
        }

        return mediaItems
    }
}
