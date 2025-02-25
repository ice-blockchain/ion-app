// SPDX-License-Identifier: ice License 1.0

// import 'dart:typed_data';

// import 'package:bech32/bech32.dart';
// import 'package:convert/convert.dart';

// /// bech32-encoded entities
// class Nip19 {
//   static String encodePubkey(String pubkey) {
//     try {
//       return bech32Encode('npub', pubkey);
//     } catch (_) {
//       return '';
//     }
//   }

//   static String encodePrivkey(String privkey) {
//     try {
//       return bech32Encode('nsec', privkey);
//     } catch (_) {
//       return '';
//     }
//   }

//   static String encodeNote(String noteid) {
//     try {
//       return bech32Encode('note', noteid);
//     } catch (_) {
//       return '';
//     }
//   }

//   static String decodePubkey(String data) {
//     try {
//       final map = bech32Decode(data);
//       if (map['prefix'] == 'npub') {
//         return map['data']!;
//       } else {
//         return '';
//       }
//     } catch (_) {
//       return '';
//     }
//   }

//   static String decodePrivkey(String data) {
//     final map = bech32Decode(data);
//     if (map['prefix'] == 'nsec') {
//       return map['data']!;
//     } else {
//       return '';
//     }
//   }

//   static String decodeNote(String data) {
//     try {
//       final map = bech32Decode(data);
//       if (map['prefix'] == 'note') {
//         return map['data']!;
//       } else {
//         return '';
//       }
//     } catch (_) {
//       return '';
//     }
//   }

//   // 0: special
//   // depends on the bech32 prefix:
//   // for nprofile it will be the 32 bytes of the profile public key
//   // for nevent it will be the 32 bytes of the event id
//   // for nrelay, this is the relay URL
//   // for naddr, it is the identifier (the "d" tag) of the event being referenced
//   // 1: relay
//   // for nprofile, nevent and naddr, optionally, a relay in which the entity (profile or event) is more likely to be found, encoded as ascii
//   // this may be included multiple times
//   // 2: author
//   // for naddr, the 32 bytes of the pubkey of the event
//   // for nevent, optionally, the 32 bytes of the pubkey of the event
//   // 3: kind
//   // for naddr, the 32-bit unsigned integer of the kind, big-endian
//   // for nevent, optionally, the 32-bit unsigned integer of the kind, big-endian
//   static String encodeShareableEntity(
//     String prefix,
//     String special,
//     List<String>? relays,
//     String? author,
//     int? kind,
//   ) {
//     // 0:special
//     if (prefix == 'naddr') {
//       special = special.codeUnits.map((number) => number.toRadixString(16).padLeft(2, '0')).join();
//     }
//     var result = '00${hexToBytes(special).length.toRadixString(16).padLeft(2, '0')}$special';
//     // 1:relay
//     if (relays != null) {
//       for (final relay in relays) {
//         result = '${result}01';
//         final value =
//             relay.codeUnits.map((number) => number.toRadixString(16).padLeft(2, '0')).join();
//         result = '$result${hexToBytes(value).length.toRadixString(16).padLeft(2, '0')}$value';
//       }
//     }
//     // 2:author
//     if (author != null) {
//       result = '${result}02';
//       result = '$result${hexToBytes(author).length.toRadixString(16).padLeft(2, '0')}$author';
//     }
//     // 3: kind
//     if (kind != null) {
//       result = '${result}03';
//       final byteData = ByteData(4);
//       byteData.setUint32(0, kind);
//       final value = List.generate(
//         byteData.lengthInBytes,
//         (index) => byteData.getUint8(index).toRadixString(16).padLeft(2, '0'),
//       ).join();
//       result = '$result${hexToBytes(value).length.toRadixString(16).padLeft(2, '0')}$value';
//     }
//     return bech32Encode(prefix, result, maxLength: result.length + 90);
//   }

//   static Map<String, dynamic> decodeShareableEntity(String shareableEntity) {
//     try {
//       var prefix = '';
//       var special = '';
//       final relays = <String>[];
//       String? author;
//       int? kind;
//       final decodedMap = bech32Decode(shareableEntity, maxLength: shareableEntity.length);
//       prefix = decodedMap['prefix']!;
//       final data = hexToBytes(decodedMap['data']!);

//       var index = 0;
//       while (index < data.length) {
//         final type = data[index++];
//         final length = data[index++];

//         final value = data.sublist(index, index + length);
//         index += length;

//         if (type == 0) {
//           special = (prefix == 'naddr') ? String.fromCharCodes(value) : bytesToHex(value);
//         } else if (type == 1) {
//           relays.add(String.fromCharCodes(value));
//         } else if (type == 2) {
//           author = bytesToHex(value);
//         } else if (type == 3) {
//           final byteData = ByteData.sublistView(value);
//           kind = byteData.getUint32(0);
//         }
//       }

//       return {
//         'prefix': prefix,
//         'special': special,
//         'relays': relays,
//         'author': author,
//         'kind': kind,
//       };
//     } catch (_) {
//       return {'prefix': ''};
//     }
//   }
// }

// /// help functions

// String bech32Encode(String prefix, String hexData, {int? maxLength}) {
//   final data = hex.decode(hexData);
//   final convertedData = convertBits(data, 8, 5, true);
//   final bech32Data = Bech32(prefix, convertedData);
//   if (maxLength != null) return bech32.encode(bech32Data, maxLength);
//   return bech32.encode(bech32Data);
// }

// Map<String, String> bech32Decode(String bech32Data, {int? maxLength}) {
//   final decodedData =
//       maxLength != null ? bech32.decode(bech32Data, maxLength) : bech32.decode(bech32Data);
//   final convertedData = convertBits(decodedData.data, 5, 8, false);
//   final hexData = hex.encode(convertedData);

//   return {'prefix': decodedData.hrp, 'data': hexData};
// }

// List<int> convertBits(List<int> data, int fromBits, int toBits, bool pad) {
//   var acc = 0;
//   var bits = 0;
//   final maxv = (1 << toBits) - 1;
//   final result = <int>[];

//   for (final value in data) {
//     if (value < 0 || value >> fromBits != 0) {
//       throw Exception('Invalid value: $value');
//     }
//     acc = (acc << fromBits) | value;
//     bits += fromBits;

//     while (bits >= toBits) {
//       bits -= toBits;
//       result.add((acc >> bits) & maxv);
//     }
//   }

//   if (pad) {
//     if (bits > 0) {
//       result.add((acc << (toBits - bits)) & maxv);
//     }
//   } else if (bits >= fromBits || ((acc << (toBits - bits)) & maxv) != 0) {
//     throw Exception('Invalid data');
//   }

//   return result;
// }

// class Nip21 {
//   static String? decode(String content) {
//     final regExp = RegExp('nostr:');
//     final match = regExp.matchAsPrefix(content);
//     if (match != null) {
//       return content.substring(match.end);
//     }
//     return null;
//   }

//   static String encode(String content) {
//     return 'nostr:$content';
//   }
// }

// String bytesToHex(Uint8List bytes) {
//   return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
// }

// Uint8List hexToBytes(String hex) {
//   final bytes = <int>[];
//   for (var i = 0; i < hex.length; i += 2) {
//     bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
//   }
//   return Uint8List.fromList(bytes);
// }
