// SPDX-License-Identifier: ice License 1.0

import Foundation
import Compression

class Decompressor {
    /// Decompresses zlib compressed data
    static func decompress(data: Data) -> Data? {
        guard !data.isEmpty else { return nil }
        
        let destinationBufferSize = data.count * 4
        let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: destinationBufferSize)
        defer { destinationBuffer.deallocate() }
        
        let decodedSize = data.withUnsafeBytes { (sourceBuffer: UnsafeRawBufferPointer) -> Int in
            guard let baseAddress = sourceBuffer.baseAddress else { return 0 }
            
            return compression_decode_buffer(
                destinationBuffer,
                destinationBufferSize,
                baseAddress.assumingMemoryBound(to: UInt8.self),
                data.count,
                nil,
                COMPRESSION_ZLIB
            )
        }
        
        guard decodedSize > 0 else { return nil }
        
        return Data(bytes: destinationBuffer, count: decodedSize)
    }
    
    /// Decodes base64 string, decompresses it, and returns as a string
    static func decompressBase64String(_ base64String: String) throws -> String {
        guard let data = Data(base64Encoded: base64String) else {
            throw DecompressionError.invalidBase64Data
        }
        
        guard let decompressedData = decompress(data: data) else {
            throw DecompressionError.decompressionFailed
        }
        
        guard let decompressedString = String(data: decompressedData, encoding: .utf8) else {
            throw DecompressionError.stringConversionFailed
        }
        
        return decompressedString
    }
}

enum DecompressionError: Error {
    case invalidBase64Data
    case decompressionFailed
    case stringConversionFailed
    case jsonDataConversionFailed
}
