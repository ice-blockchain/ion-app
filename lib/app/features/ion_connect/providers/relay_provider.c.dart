// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_active_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_auth_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_closed_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_timer_mixin.dart';
import 'package:ion/app/features/user/providers/relays_reachability_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_provider.c.g.dart';

typedef RelaysState = Map<String, IonConnectRelay>;

@Riverpod(keepAlive: true)
class Relay extends _$Relay
    with RelayTimerMixin, RelayAuthMixin, RelayClosedMixin, RelayActiveMixin {
  @override
  Future<IonConnectRelay> build(String url, {bool anonymous = false}) async {
    final relay = await _getRelay(url);

    trackRelayAsActive(relay, ref);
    initializeRelayTimer(relay, ref);
    initializeRelayClosedListener(relay, ref);

    if (!anonymous) {
      await initializeAuth(relay, ref);
    }

    ref.onDispose(relay.close);

    return relay;
  }

  Future<IonConnectRelay> _getRelay(String url) async {
    final socket = WebSocket(Uri.parse(url));
    final relay = IonConnectRelay(url: url, socket: socket);
    final connectionState = await socket.connection.firstWhere(
      (state) => state is Connected || state is Reconnected || state is Disconnected,
    );
    if (_isRelayUnreachable(connectionState)) {
      socket.close();
      await _updateRelayReachabilityInfo(url);
      throw RelayUnreachableException(url);
    }
    await ref.read(relayReachabilityProvider.notifier).clear(url);
    return relay;
  }

  bool _isRelayUnreachable(ConnectionState connectionState) {
    if (connectionState is! Disconnected) {
      return false;
    }
    final error = connectionState.error;
    if (error == null || error is! SocketException) {
      return false;
    }
    final osError = error.osError;
    if (osError == null) {
      return false;
    }
    return _unreachableRelayErrorCodes.contains(osError.errorCode);
  }

  List<int> get _unreachableRelayErrorCodes => [
        8, // android connection refused
        61, // ios connection refused
      ];

  Future<void> _updateRelayReachabilityInfo(String url) async {
    final relayReachabilityInfo = ref.read(relayReachabilityProvider.notifier).get(url);
    final updatedReachabilityInfo = _getUpdatedReachabilityInfo(relayReachabilityInfo);
    await ref.read(relayReachabilityProvider.notifier).save(updatedReachabilityInfo);
  }

  RelayReachabilityInfo _getUpdatedReachabilityInfo(RelayReachabilityInfo? reachabilityInfo) {
    if (reachabilityInfo == null) {
      return RelayReachabilityInfo(
        relayUrl: url,
        failedToReachCount: 1,
        lastFailedToReachDate: DateTime.now(),
      );
    }
    final timeDifference = DateTime.now().difference(reachabilityInfo.lastFailedToReachDate).abs();
    if (timeDifference.inHours < 1) {
      return reachabilityInfo;
    }

    return RelayReachabilityInfo(
      relayUrl: url,
      failedToReachCount: reachabilityInfo.failedToReachCount + 1,
      lastFailedToReachDate: DateTime.now(),
    );
  }
}
