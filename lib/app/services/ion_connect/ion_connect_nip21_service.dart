class Nip21 {
  static const String _prefix = 'nostr:';

  /// Parses a `nostr:` URI and extracts the identifier.
  ///
  /// Throws an [Exception] if the prefix `nostr:` is missing
  static String? decode(String uri) {
    if (!uri.startsWith(_prefix)) {
      return null;
    }

    return uri.substring(_prefix.length);
  }

  /// Generates a `nostr:` URI from a given content
  static String encode(String content) => _prefix + content;
}
