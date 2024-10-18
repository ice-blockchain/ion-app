// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/features/auth/providers/user_tokens_stream_provider.dart';
import 'package:ice/app/features/auth/services/refresh_tokens_service.dart';
import 'package:ice/app/features/core/providers/app_lifecycle_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'refresh_token_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> refreshTokens(RefreshTokensRef ref) async {
  final refreshTokensService = await ref.watch(refreshTokensServiceProvider.future);

  ref
    ..listen(
      userTokensStreamProvider,
      (previous, next) async {
        final prevSet = Set.of(previous?.valueOrNull ?? <UserToken>{});
        final nextSet = Set.of(next.valueOrNull ?? <UserToken>{});

        final removedTokens = nextSet.difference(prevSet);
        refreshTokensService.removeTokens(removedTokens);

        final newTokens = nextSet.difference(prevSet);
        refreshTokensService.addTokens(newTokens);
      },
      fireImmediately: true,
    )
    ..listen(appLifecycleProvider, (previous, next) async {
      if (next == AppLifecycleState.paused) {
        refreshTokensService.dispose();
      } else if (next == AppLifecycleState.resumed) {
        final tokens = await ref.read(userTokensStreamProvider.future);
        refreshTokensService.addTokens(tokens);
      }
    });
}
