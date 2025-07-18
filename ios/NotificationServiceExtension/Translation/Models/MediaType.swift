// SPDX-License-Identifier: ice License 1.0

import Foundation

enum MediaType: String, Codable {
    case image
    case gif
    case video
    case audio
    case document
    case unknown
    
    static func fromMimeType(_ mimeType: String) -> MediaType {
        if mimeType.hasPrefix("image/") {
            return mimeType.contains("gif") ? .gif : .image
        } else if mimeType.hasPrefix("video/") {
            return .video
        } else if mimeType.hasPrefix("audio/") {
            return .audio
        } else if mimeType.hasPrefix("application/") {
            return .document
        }
        
        return .unknown
    }
    
    static func fromUrl(_ url: String) -> MediaType {
        if isImageUrl(url) {
            return .image
        } else if isVideoUrl(url) {
            return .video
        } else if isAudioUrl(url) {
            return .audio
        } else if isDocumentUrl(url) {
            return .document
        }
        
        return .unknown
    }
    
    static func isImageUrl(_ url: String) -> Bool {
        let pattern = "https?://\\S+\\.(?:jpg|jpeg|png|gif|bmp|svg|webp)"
        return url.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func isVideoUrl(_ url: String) -> Bool {
        let pattern = "https?://\\S+\\.(?:mp4|avi|mov|wmv|flv|mkv|webm)"
        return url.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func isAudioUrl(_ url: String) -> Bool {
        let pattern = "https?://\\S+\\.(?:mp3|wav|ogg|flac|aac|wma)"
        return url.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func isDocumentUrl(_ url: String) -> Bool {
        let pattern = "https?://\\S+\\.(?:pdf|doc|docx|xls|xlsx|ppt|pptx|txt|rtf)"
        return url.range(of: pattern, options: .regularExpression) != nil
    }
}
