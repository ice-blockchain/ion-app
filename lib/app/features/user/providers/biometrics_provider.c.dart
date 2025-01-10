// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometrics_provider.c.g.dart';

@riverpod
Future<BiometricsState?> userBiometricsState(
  Ref ref, {
  required String username,
}) async {
  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  return ionIdentity(username: username).auth.getBiometricsState();
}

@Riverpod(keepAlive: true)
Stream<Map<String, BiometricsState>> biometricsStatesStream(Ref ref) async* {
  final ionIdentity = await ref.watch(ionIdentityProvider.future);

  yield* ionIdentity.biometricsStatesStream;
}

@riverpod
class BiometricsActionsNotifier extends _$BiometricsActionsNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> rejectToUseBiometrics({required String username}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      await ionIdentity(username: username).auth.rejectToUseBiometrics();
    });
  }

  Future<void> enrollToUseBiometrics({
    required String username,
    required String localisedReason,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      await ionIdentity(username: username).auth.enrollToUseBiometrics(
            localisedReason: localisedReason,
          );
    });
  }
}
