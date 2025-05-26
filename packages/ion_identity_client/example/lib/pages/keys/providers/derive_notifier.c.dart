import 'package:ion_identity_client_example/providers/ion_identity_client_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'derive_notifier.c.g.dart';

@riverpod
class DeriveKeyNotifier extends _$DeriveKeyNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> derive() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);

      final domain = 'ion:ion-app:1'.codeUnits.map((e) => e.toRadixString(16)).join();
      final seed = 'username'.codeUnits.map((e) => e.toRadixString(16)).join();

      const keyId = '';

      await ionIdentityClient.keys.derive(
        keyId: keyId,
        domain: domain,
        seed: seed,
        onVerifyIdentity: ({
          required onBiometricsFlow,
          required onPasskeyFlow,
          required onPasswordFlow,
        }) =>
            onPasskeyFlow(),
      );
    });
  }
}
