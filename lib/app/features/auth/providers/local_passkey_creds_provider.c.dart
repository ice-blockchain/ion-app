// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_passkey_creds_provider.c.g.dart';

@riverpod
Future<LocalPasskeyCredsState?> userLocalPasskeyCredsState(
  Ref ref, {
  required String username,
}) async {
  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  return ionIdentity(username: username).auth.getLocalPasskeyCredsState();
}

@Riverpod(keepAlive: true)
Stream<Map<String, LocalPasskeyCredsState>> localPasskeyCredsStatesStream(Ref ref) async* {
  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  yield* ionIdentity.localPasskeyCredsStateStream;
}

@riverpod
class RejectToCreateLocalPasskeyCredsNotifier extends _$RejectToCreateLocalPasskeyCredsNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> rejectToCreateLocalPasskeyCreds({required String username}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final hasUserMetadata = ref.read(currentUserMetadataProvider).valueOrNull != null;
        if (hasUserMetadata) {
          await ref.read(onboardingCompleteNotifierProvider.notifier).addDelegation(
                ({
                  required onPasskeyFlow,
                  required onPasswordFlow,
                  required onBiometricsFlow,
                }) =>
                    onPasskeyFlow(),
              );
        }
      } catch (error, stackTrace) {
        Logger.log(
          'Error during add delegation flow',
          error: error,
          stackTrace: stackTrace,
        );
      }
      final ionIdentity = await ref.watch(ionIdentityProvider.future);
      await ionIdentity(username: username).auth.rejectToCreateLocalPasskeyCreds();
    });
  }
}

@riverpod
class AcceptToCreateLocalPasskeyCredsNotifier extends _$AcceptToCreateLocalPasskeyCredsNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> createLocalPasskeyCreds({
    required String username,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);

      try {
        await ionIdentity(username: username).auth.createLocalPasskeyCreds();
      } on PasskeyCancelledException {
        return;
      }
    });
  }
}
