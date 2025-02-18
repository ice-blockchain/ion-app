// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/model/auth_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_auth_mixin.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_auth_notifier.c.g.dart';

@riverpod
class RelayAuthNotifier extends _$RelayAuthNotifier {
  @override
  FutureOr<void> build(IonConnectRelay relay) {}

  Future<void> initRelayAuth() async {
    final signedAuthEvent = await _createAuthEvent(
      challenge: 'init',
      relayUrl: Uri.parse(relay.url).toString(),
    );

    try {
      await relay.sendEvents([signedAuthEvent]);
    } catch (error, _) {
      if (isRelayAuthError(error)) {
        await sendAuthEvent();
      } else {
        rethrow;
      }
    }
  }

  Future<void> sendAuthEvent() async {
    final challenge = ref.read(relayAuthChallengeProvider(relay));
    if (challenge == null || challenge.isEmpty) throw AuthChallengeIsEmptyException();

    final signedAuthEvent = await _createAuthEvent(
      challenge: challenge,
      relayUrl: Uri.parse(relay.url).toString(),
    );

    final authMessage = AuthMessage(
      challenge: jsonEncode(signedAuthEvent.toJson().last),
    );
    relay.sendMessage(authMessage);

    final okMessages = await relay.messages
        .where((message) => message is OkMessage)
        .cast<OkMessage>()
        .firstWhere((message) => signedAuthEvent.id == message.eventId);

    if (!okMessages.accepted) {
      throw SendEventException(okMessages.message);
    }

    ref.read(relayAuthCompleterProvider(relay)).complete();
  }

  Future<EventMessage> _createAuthEvent({
    required String challenge,
    required String relayUrl,
  }) async {
    final authEvent = AuthEvent(
      challenge: challenge,
      relay: relayUrl,
    );

    final delegation = await ref.read(currentUserCachedDelegationProvider.future);
    return ref
        .read(ionConnectNotifierProvider.notifier)
        .sign(authEvent, includeMasterPubkey: delegation != null);
  }
}

bool isRelayAuthError(Object? error) {
  final isSubscriptionAuthRequired = error is RelayRequestFailedException &&
      error.event is ClosedMessage &&
      (error.event as ClosedMessage).message.startsWith('auth-required');
  final isSendEventAuthRequired =
      error != null && (error is SendEventException) && error.code.startsWith('auth-required');
  return isSubscriptionAuthRequired || isSendEventAuthRequired;
}
