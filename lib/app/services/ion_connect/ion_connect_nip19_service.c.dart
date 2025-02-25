// ignore_for_file: use_string_buffers

import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:convert/convert.dart';

/// bech32-encoded entities
///
/// This NIP standardizes bech32-formatted strings that can be used to display keys,
/// ids and other information in clients. These formats are not meant to be used anywhere
/// in the core protocol, they are only meant for displaying to users, copy-pasting,
/// sharing, rendering QR codes and inputting data.
class Nip19 {
  static const _shareableIdentifiersPrefixes = [
    Nip19Prefix.nprofile,
    Nip19Prefix.nevent,
    Nip19Prefix.naddr,
  ];

  /// The bech32 npub `npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyjh6w6`
  /// translates to the hex public key `3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d`
  static ({Nip19Prefix prefix, String data}) decode({required String payload}) {
    final decoded = bech32Decode(payload);
    if (_shareableIdentifiersPrefixes.contains(decoded.prefix)) {
      throw Exception('use ${Nip19.decodeShareableIdentifiers} instead');
    }
    return decoded;
  }

  /// The hex public key `3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d`
  /// translates to `npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyjh6w6`
  static String encode({
    required Nip19Prefix prefix,
    required String data,
  }) {
    if (_shareableIdentifiersPrefixes.contains(prefix)) {
      throw Exception('use ${Nip19.encodeShareableIdentifiers} instead');
    }
    return bech32Encode(prefix, data);
  }

  /// Encode shareable identifiers (nprofile, nevent, naddr) as TLV data
  static String encodeShareableIdentifiers({
    required Nip19Prefix prefix,
    required String special,
    List<String>? relays,
    String? author,
    int? kind,
  }) {
    if (!_shareableIdentifiersPrefixes.contains(prefix)) {
      throw Exception('$prefix not in $_shareableIdentifiersPrefixes');
    }

    // 0: special
    if (prefix == Nip19Prefix.naddr) {
      special = special.codeUnits.map((number) => number.toRadixString(16).padLeft(2, '0')).join();
    }
    var result = '00${hex.decode(special).length.toRadixString(16).padLeft(2, '0')}$special';

    // 1: relay
    if (relays != null) {
      for (final relay in relays) {
        result = '${result}01';
        final value =
            relay.codeUnits.map((number) => number.toRadixString(16).padLeft(2, '0')).join();
        result = '$result${hex.decode(value).length.toRadixString(16).padLeft(2, '0')}$value';
      }
    }

    // 2: author
    if (author != null) {
      result = '${result}02';
      result = '$result${hex.decode(author).length.toRadixString(16).padLeft(2, '0')}$author';
    }

    // 3: kind
    if (kind != null) {
      result = '${result}03';
      final byteData = ByteData(4)..setUint32(0, kind);
      final value = List.generate(
        byteData.lengthInBytes,
        (index) => byteData.getUint8(index).toRadixString(16).padLeft(2, '0'),
      ).join();
      result = '$result${hex.decode(value).length.toRadixString(16).padLeft(2, '0')}$value';
    }
    return bech32Encode(prefix, result, length: result.length + 90);
  }

  /// For these events, the contents are a binary-encoded list of TLV (type-length-value),
  /// with T and L being 1 byte each (uint8, i.e. a number in the range of 0-255),
  ///  and V being a sequence of bytes of the size indicated by L.
  ///
  /// 0: special depends on the bech32 prefix:
  /// - for nprofile it will be the 32 bytes of the profile public key
  /// - for nevent it will be the 32 bytes of the event id
  /// - for naddr, it is the identifier (the "d" tag) of the event being referenced. For normal replaceable events use an empty string.
  ///
  /// 1: relay for nprofile, nevent and naddr, optionally, a relay in which the entity
  /// (profile or event) is more likely to be found, encoded as ascii this may be included multiple times
  ///
  /// 2: author
  /// - for naddr, the 32 bytes of the pubkey of the event
  /// - for nevent, optionally, the 32 bytes of the pubkey of the event
  ///
  /// 3: kind
  /// - for naddr, the 32-bit unsigned integer of the kind, big-endian
  /// - for nevent, optionally, the 32-bit unsigned integer of the kind, big-endian
  static ShareableIdentifiers? decodeShareableIdentifiers({
    required String? payload,
  }) {
    try {
      if (payload == null) {
        return null;
      }
      var special = '';
      final relays = <String>[];
      String? author;
      int? kind;
      final decoded = bech32Decode(payload, length: payload.length);
      final data = hex.decode(decoded.data);

      var index = 0;
      while (index < data.length) {
        final type = data[index++];
        final length = data[index++];

        final value = Uint8List.fromList(data.sublist(index, index + length));
        index += length;

        if (type == 0) {
          special = (decoded.prefix == Nip19Prefix.naddr)
              ? String.fromCharCodes(value)
              : hex.encode(value);
        } else if (type == 1) {
          relays.add(String.fromCharCodes(value));
        } else if (type == 2) {
          author = hex.encode(value);
        } else if (type == 3) {
          final byteData = ByteData.sublistView(value);
          kind = byteData.getUint32(0);
        }
      }

      return ShareableIdentifiers(
        prefix: decoded.prefix,
        special: special,
        relays: relays,
        author: author,
        kind: kind,
      );
    } catch (e) {
      throw Exception('Failed to decode shareable entity: $e');
    }
  }
}

/// Represents all the prefixes availables
/// nrelay is deprecated
enum Nip19Prefix {
  nsec,
  npub,
  note,
  nprofile,
  nevent,
  naddr;

  static Nip19Prefix from(String name) => Nip19Prefix.values.byName(name.toLowerCase());
}

/// Shareable identifiers with extra metadata
/// When sharing a profile or an event, an app may decide to include relay information
/// and other metadata such that other apps can locate and display these entities
/// more easily.
class ShareableIdentifiers {
  ShareableIdentifiers({
    required this.prefix,
    required this.special,
    this.relays = const [],
    this.author,
    this.kind,
  });
  final Nip19Prefix prefix;
  final String special;
  List<String> relays;
  String? author;
  int? kind;
}

String bech32Encode(Nip19Prefix prefix, String hexData, {int? length}) {
  final data = hex.decode(hexData);
  final convertedData = _convertBits(data, 8, 5, true);
  final bech32Data = Bech32(prefix.name, convertedData);
  if (length != null) {
    return bech32.encode(bech32Data, length);
  }
  return bech32.encode(bech32Data);
}

({Nip19Prefix prefix, String data}) bech32Decode(
  String bech32Data, {
  int? length,
}) {
  final decodedData =
      length != null ? bech32.decode(bech32Data, length) : bech32.decode(bech32Data);
  final convertedData = _convertBits(decodedData.data, 5, 8, false);
  final hexData = hex.encode(convertedData);
  return (prefix: Nip19Prefix.from(decodedData.hrp), data: hexData);
}

List<int> _convertBits(List<int> data, int fromBits, int toBits, bool pad) {
  var acc = 0;
  var bits = 0;
  final maxv = (1 << toBits) - 1;
  final result = <int>[];

  for (final value in data) {
    if (value < 0 || value >> fromBits != 0) {
      throw Exception('Invalid value: $value');
    }
    acc = (acc << fromBits) | value;
    bits += fromBits;

    while (bits >= toBits) {
      bits -= toBits;
      result.add((acc >> bits) & maxv);
    }
  }

  if (pad) {
    if (bits > 0) {
      result.add((acc << (toBits - bits)) & maxv);
    }
  } else if (bits >= fromBits || ((acc << (toBits - bits)) & maxv) != 0) {
    throw Exception('Invalid data');
  }

  return result;
}

class NostrTypeGuard {
  static bool isNProfile(String? value) =>
      RegExp(r'^nostr:nprofile1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isNEvent(String? value) => RegExp(r'^nostr:nevent1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isNAddr(String? value) => RegExp(r'^nostr:naddr1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isNSec(String? value) => RegExp(r'^nostr:nsec1[a-z0-9]{58}$').hasMatch(value ?? '');
  static bool isNPub(String? value) => RegExp(r'^nostr:npub1[a-z0-9]{58}$').hasMatch(value ?? '');
  static bool isNote(String? value) => RegExp(r'^nostr:note1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isNCryptSec(String? value) =>
      RegExp(r'^nostr:ncryptsec1[a-z0-9]+$').hasMatch(value ?? '');
}
