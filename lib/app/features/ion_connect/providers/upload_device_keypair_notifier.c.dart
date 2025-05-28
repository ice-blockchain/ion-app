import 'package:collection/collection.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_device_keypair_notifier.c.g.dart';

@riverpod
class UploadDeviceKeypairNotifier extends _$UploadDeviceKeypairNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> uploadDeviceKeypair({
    required String identityKeyName,
    required OnVerifyIdentity<KeyResponse> onVerifyIdentityForCreateKey,
    required OnVerifyIdentity<DeriveResponse> onVerifyIdentityForDerive,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final deviceKeypair = await ref.read(currentUserIonConnectEventSignerProvider.future);
      if (deviceKeypair == null) {
        return;
      }

      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      final keysResponse = await ionIdentity.keys.listKeys(owner: identityKeyName);
      var deviceKey = keysResponse.items.firstWhereOrNull((key) => key.name == 'device');

      if (deviceKey == null) {
        final createKeyResult = await ionIdentity.keys.createKey(
          scheme: 'DH',
          curve: 'curve',
          name: 'device',
          onVerifyIdentity: onVerifyIdentityForCreateKey,
        );
        deviceKey = createKeyResult;
      }

      final deriviation = await ionIdentity.keys.derive(
        keyId: deviceKey.id,
        domain: 'ion:ion-app:1',
        seed: deviceKeypair.publicKey,
        onVerifyIdentity: onVerifyIdentityForDerive,
      );

      return;
    });
  }
}
