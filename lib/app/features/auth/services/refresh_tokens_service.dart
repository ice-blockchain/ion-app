// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'refresh_tokens_service.g.dart';

@Riverpod(keepAlive: true)
Future<RefreshTokensService> refreshTokensService(RefreshTokensServiceRef ref) async {
  final refreshTokenService = RefreshTokensService(await ref.watch(ionApiClientProvider.future));

  ref.onDispose(refreshTokenService.dispose);

  return refreshTokenService;
}

class RefreshTokensService {
  RefreshTokensService(this._ionApiClient);

  final IonApiClient _ionApiClient;
  final _refreshTimers = <String, Timer>{};

  void removeTokens(Iterable<UserToken> tokens) {
    for (final token in tokens) {
      final timer = _refreshTimers.remove(token.username);
      timer?.cancel();
    }
  }

  void addTokens(Iterable<UserToken> tokens) {
    for (final token in tokens) {
      if (_refreshTimers.containsKey(token.username)) {
        continue;
      }
      _scheduleTokenRefresh(token);
    }
  }

  void _scheduleTokenRefresh(UserToken token) {
    final now = DateTime.now();
    final timeUntilExpiration = token.expiresAt.difference(now);

    // Refresh 5 minutes before expiration or immediately if less than 5 minutes left
    final refreshDelay = timeUntilExpiration - const Duration(minutes: 5);
    final timer = Timer(
      refreshDelay.isNegative ? Duration.zero : refreshDelay,
      () => _refreshToken(token),
    );
    _refreshTimers[token.username] = timer;
  }

  Future<void> _refreshToken(UserToken token) async {
    try {
      final newToken = await _ionApiClient(username: token.username).auth.delegatedLogin();
      // After successful refresh, schedule the next refresh
      _scheduleTokenRefresh(newToken);
    } catch (e) {
      // Retry after a short delay
      Timer(const Duration(minutes: 1), () => _refreshToken(token));
    }
  }

  void dispose() {
    for (final timer in _refreshTimers.values) {
      timer.cancel();
    }
    _refreshTimers.clear();
  }
}
