// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:nostr_dart/nostr_dart.dart';

extension MasterKeyExtensions on EventMessage {
  String get masterPubkey {
    final masterPubkey = tags.firstWhereOrNull((tags) => tags[0] == 'b')?.elementAtOrNull(1);

    if (masterPubkey == null) {
      throw EventMasterPubkeyNotFoundException(eventId: id);
    }

    return masterPubkey;
  }

  String? get subject {
    return tags.singleWhereOrNull((tag) => tag[0] == 'subject')?[1];
  }

  String get pubkeysMask {
    return pubkeysList.join(',');
  }

  List<String> get pubkeysList {
    return tags.where((tag) => tag[0] == 'p').map((tag) => tag[1]).toList()
      ..add(pubkey)
      ..sort();
  }
}
