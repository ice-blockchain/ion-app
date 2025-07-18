// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/providers/relays_reachability_provider.r.dart';

mixin RelayCreateMixin {
  Future<IonConnectRelay> createRelay(Ref ref, String url) async {
    final socket = WebSocket(Uri.parse(url));
    final relay = IonConnectRelay(url: url, socket: socket);
    final connectionState = await socket.connection.firstWhere(
      (state) => state is Connected || state is Reconnected || state is Disconnected,
    );
    if (_isRelayUnreachable(connectionState)) {
      socket.close();
      await _updateRelayReachabilityInfo(ref, url);
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

  Future<void> _updateRelayReachabilityInfo(Ref ref, String url) async {
    final relayReachabilityInfo = ref.read(relayReachabilityProvider.notifier).get(url);
    final updatedReachabilityInfo = _getUpdatedReachabilityInfo(url, relayReachabilityInfo);
    await ref.read(relayReachabilityProvider.notifier).save(updatedReachabilityInfo);
  }

  RelayReachabilityInfo _getUpdatedReachabilityInfo(
    String url,
    RelayReachabilityInfo? reachabilityInfo,
  ) {
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
