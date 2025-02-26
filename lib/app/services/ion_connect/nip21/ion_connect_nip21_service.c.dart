// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_nip21_service.c.g.dart';

///
/// https://github.com/nostr-protocol/nips/blob/master/21.md
///
class IonConnectNip21Service {
  static const String _prefix = 'nostr:';

  String? decode(String uri) {
    if (!uri.startsWith(_prefix)) {
      return null;
    }

    return uri.substring(_prefix.length);
  }

  String encode(String content) => _prefix + content;
}

@riverpod
IonConnectNip21Service ionConnectNip21Service(Ref ref) {
  return IonConnectNip21Service();
}
