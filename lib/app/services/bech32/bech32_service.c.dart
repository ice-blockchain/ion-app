// SPDX-License-Identifier: ice License 1.0

import 'package:bech32/bech32.dart';
import 'package:convert/convert.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/ion_connect/ion_connect_protocol_identifier_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bech32_service.c.g.dart';

class Bech32Service {
  String encode(IonConnectProtocolIdentifierType prefix, String hexData, {int? length}) {
    final data = hex.decode(hexData);
    final convertedData = _convertBits(data, 8, 5, true);
    final bech32Data = Bech32(prefix.name, convertedData);
    if (length != null) {
      return bech32.encode(bech32Data, length);
    }
    return bech32.encode(bech32Data);
  }

  ({IonConnectProtocolIdentifierType prefix, String data}) decode(
    String bech32Data, {
    int? length,
  }) {
    final decodedData =
        length != null ? bech32.decode(bech32Data, length) : bech32.decode(bech32Data);
    final convertedData = _convertBits(decodedData.data, 5, 8, false);
    final hexData = hex.encode(convertedData);
    return (prefix: IonConnectProtocolIdentifierType.from(decodedData.hrp), data: hexData);
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
}

@riverpod
Bech32Service bech32Service(Ref ref) {
  return Bech32Service();
}
