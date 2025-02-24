// SPDX-License-Identifier: ice License 1.0

class NProfileKey {
  const NProfileKey({
    required this.masterPubkey,
  });

  static const String _nostrKey = 'nostr';
  static const String _nprofileKey = 'nprofile';
  static const String _separator = ':';

  static String? parse(String content) {
    if (content.isEmpty) {
      return null;
    }

    final parts = content.split(_separator);
    if (parts.length < 3 || parts[0] != _nostrKey || parts[1] != _nprofileKey) {
      return null;
    }

    return parts[2];
  }

  final String masterPubkey;

  String get encode {
    return [_nostrKey, _nprofileKey, masterPubkey].join(_separator);
  }
}
