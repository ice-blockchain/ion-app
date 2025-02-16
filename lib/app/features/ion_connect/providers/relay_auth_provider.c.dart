// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/auth_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_auth_provider.c.g.dart';

// Keeping the state mutable intentionally
class RelayAuthState {
  RelayAuthState({required this.completer});

  Completer<void> completer;
  String? challenge;
}

@riverpod
class RelayAuth extends _$RelayAuth {
  @override
  RelayAuthState build(IonConnectRelay relay) {
    final authMessageSubscription = relay.messages.listen((message) {
      if (message is AuthMessage) {
        state.challenge = message.challenge;
      }
    });
    ref.onDispose(authMessageSubscription.cancel);

    return RelayAuthState(completer: Completer());
  }

  Future<void> initRelayAuth() async {
    final signedAuthEvent = await _createAuthEvent(
      challenge: 'init',
      relayUrl: Uri.parse(relay.url).toString(),
    );

    try {
      await relay.sendEvents([signedAuthEvent]);
    } catch (error) {
      if (isRelayAuthError(error)) {
        await authenticateRelay();
      } else {
        rethrow;
      }
    }
  }

  /// Handles relay authentication during send / request actions.
  ///
  /// Triggers the relay authentication process if relay requested it.
  /// Waits for ongoing authentication to complete before processing.
  Future<void> handleRelayAuthOnAction({
    required ActionSource actionSource,
    required Object? error,
  }) async {
    if (isRelayAuthError(error)) {
      if (!actionSource.anonymous) {
        await authenticateRelay();
      } else {
        throw AnonymousRelayAuthException();
      }
    }
    if (!actionSource.anonymous) {
      await state.completer.future;
    }
  }

  Future<void> authenticateRelay() async {
    final challenge = state.challenge;
    if (challenge == null || challenge.isEmpty) throw AuthChallengeIsEmptyException();

    // Cases when we need to re-authenticate the relay:
    // when we obtained a user delegation and need to re-authenticate with the `b` tag
    // when BE requested re-authentication (in response to sending an event or starting a subscription)
    if (state.completer.isCompleted) {
      state.completer = Completer();
    }

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

    state.completer.complete();
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
      error is SendEventException && error.code.startsWith('auth-required');
  return isSubscriptionAuthRequired || isSendEventAuthRequired;
}
