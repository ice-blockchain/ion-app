// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' hide requestEvents;
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/auth_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_auth_provider.c.g.dart';

@riverpod
class RelayAuth extends _$RelayAuth {
  @override
  RelayAuthService build(IonConnectRelay relay) {
    final service = RelayAuthService(
      relay: relay,
      createAuthEvent: ({
        required String challenge,
        required String relayUrl,
      }) async {
        final authEvent = AuthEvent(
          challenge: challenge,
          relay: relayUrl,
        );

        // Used cache delegation only because relay not authorized yet
        final delegationComplete = await ref.read(cacheDelegationCompleteProvider.future);
        return ref
            .read(ionConnectNotifierProvider.notifier)
            .sign(authEvent, includeMasterPubkey: delegationComplete.falseOrValue);
      },
    );

    final authMessageSubscription = relay.messages.listen((message) {
      if (message is AuthMessage) {
        service.challenge = message.challenge;
      }
    });
    ref.onDispose(authMessageSubscription.cancel);

    return service;
  }
}

class RelayAuthService {
  RelayAuthService({
    required this.relay,
    required this.createAuthEvent,
    this.completer,
  });

  final IonConnectRelay relay;

  final Future<EventMessage> Function({required String challenge, required String relayUrl})
      createAuthEvent;

  Completer<void>? completer;

  String? challenge;

  Future<void> initRelayAuth() async {
    final signedAuthEvent = await createAuthEvent(
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
      await completer?.future;
    }
  }

  Future<void> authenticateRelay() async {
    if (challenge == null || challenge!.isEmpty) throw AuthChallengeIsEmptyException();

    // Cases when we need to re-authenticate the relay:
    // * when we obtained a user delegation and need to re-authenticate with the `b` tag
    // * when BE requested re-authentication (in response to sending an event or starting a subscription)
    if (completer == null || completer!.isCompleted) {
      completer = Completer();
    } else {
      return completer!.future;
    }
    try {
      final signedAuthEvent = await createAuthEvent(
        challenge: challenge!,
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

      completer?.complete();
    } catch (error) {
      completer?.completeError(error);
    }
  }

  static bool isRelayAuthError(Object? error) {
    final isSubscriptionAuthRequired = error is RelayRequestFailedException &&
        error.event is ClosedMessage &&
        (error.event as ClosedMessage).message.startsWith('auth-required');
    final isSendEventAuthRequired =
        error is SendEventException && error.code.startsWith('auth-required');
    return isSubscriptionAuthRequired || isSendEventAuthRequired;
  }
}
