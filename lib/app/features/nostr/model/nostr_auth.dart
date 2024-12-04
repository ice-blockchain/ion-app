// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'nostr_auth.freezed.dart';

//TODO: move core nostr related models to nostr-lib
@freezed
class NostrAuth with _$NostrAuth implements EventSerializable {
  const factory NostrAuth({
    required String url,
    required String method,
    List<int>? payload,
  }) = _NostrAuth;

  const NostrAuth._();

  /// https://github.com/nostr-protocol/nips/blob/master/98.md
  @override
  Future<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
  }) async {
    final eventTags = [
      ...tags,
      ['u', url],
      ['method', method],
    ];

    if (payload != null) {
      final hash = await Sha256().hash(payload!);
      eventTags.add(
        ['payload', hex.encode(hash.bytes)],
      );
    }

    return EventMessage.fromData(
      signer: signer,
      kind: kind,
      tags: eventTags,
      content: '',
    );
  }

  String toAuthorizationHeader(EventMessage event) {
    final eventPayload = event.toJson().last;
    final headerValue = base64Encode(utf8.encode(jsonEncode(eventPayload)));
    return 'Nostr $headerValue';
  }

  static const int kind = 27235;
}
