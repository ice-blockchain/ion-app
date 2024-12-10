// SPDX-License-Identifier: ice License 1.0

// {
//   "content": "AqBCdwoS7/tPK+QGkPCadJTn8FxGkd24iApo3BR9/M0uw6n4RFAFSPAKKMgkzVMoRyR3ZS/aqATDFvoZJOkE9cPG/TAzmyZvr/WUIS8kLmuI1dCA+itFF6+ULZqbkWS0YcVU0j6UDvMBvVlGTzHz+UHzWYJLUq2LnlynJtFap5k8560+tBGtxi9Gx2NIycKgbOUv0gEqhfVzAwvg1IhTltfSwOeZXvDvd40rozONRxwq8hjKy+4DbfrO0iRtlT7G/eVEO9aJJnqagomFSkqCscttf/o6VeT2+A9JhcSxLmjcKFG3FEK3Try/WkarJa1jM3lMRQqVOZrzHAaLFW/5sXano6DqqC5ERD6CcVVsrny0tYN4iHHB8BHJ9zvjff0NjLGG/v5Wsy31+BwZA8cUlfAZ0f5EYRo9/vKSd8TV0wRb9DQ=",
//   "kind": 13,
//   "created_at": 1703015180,
//   "pubkey": "611df01bfcf85c26ae65453b772d8f1dfd25c264621c0277e1fc1518686faef9",
//   "tags": [],
//   "id": "28a87d7c074d94a58e9e89bb3e9e4e813e2189f285d797b1c56069d36f59eaa7",
//   "sig": "02fc3facf6621196c32912b1ef53bac8f8bfe9db51c0e7102c073103586b0d29c3f39bdaa1e62856c20e90b6c7cc5dc34ca8bb6a528872cf6e65e6284519ad73"
// }

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'seal_data.c.freezed.dart';

@freezed
class SealData with _$SealData {
  const factory SealData({
    required String rumor,
  }) = _SealData;

  static const kind = 13;

  FutureOr<EventMessage> encode(String pubkey, String privateKey) async {
    final encryptedRumor = await Nip44.encryptMessage(rumor, pubkey, privateKey);
    final createdAt = DateTime.now();
    final event = EventMessage(
      id: EventMessage.calculateEventId(
        publicKey: pubkey,
        kind: kind,
        createdAt: createdAt,
        content: encryptedRumor,
        tags: [],
      ),
      pubkey: pubkey,
      createdAt: createdAt,
      kind: kind,
      content: encryptedRumor,
      tags: const [],
      sig: null,
    );
    return event;
  }

  FutureOr<EventMessage> decode(String pubkey, String privateKey) async {
    final decryptedRumor = await Nip44.decryptMessage(rumor, pubkey, privateKey);
    final createdAt = DateTime.now();
    final event = EventMessage(
      id: EventMessage.calculateEventId(
        publicKey: pubkey,
        kind: kind,
        createdAt: createdAt,
        content: decryptedRumor,
        tags: [],
      ),
      pubkey: pubkey,
      createdAt: createdAt,
      kind: kind,
      content: decryptedRumor,
      tags: const [],
      sig: null,
    );
    return event;
  }
}
