import 'package:ion/app/features/protect_account/secure_account/providers/two_fa_signature_notifier.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'two_fa_signature_wrapper_notifier.c.g.dart';

typedef SignedAction = Future<void> Function(String? signature);

@Riverpod(keepAlive: true)
class TwoFaSignatureWrapperNotifier extends _$TwoFaSignatureWrapperNotifier {
  @override
  FutureOr<SignedAction?> build() async => null;

  Future<void> wrapWithSignature(SignedAction action, [String? twoFaSignature]) async {
    state = const AsyncLoading();

    try {
      state = await AsyncValue.guard(
        () async {
          final signature = twoFaSignature ?? ref.read(twoFaSignatureNotifierProvider);
          await action(signature);
          return null;
        },
        (error) {
          // return error is! InvalidSignatureException;
          return true;
        },
      );
      // } on InvalidSignatureException catch (e) {
    } catch (e) {
      // if invalid signature error, set state with failed action to retry
      // state = AsyncValue(action);
    }
  }

  Future<void> retryWithVerifyIdentity(
    SignedAction action,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final client = await ref.read(ionIdentityClientProvider.future);
      final signature = await client.auth.generateSignature(onVerifyIdentity);
      await ref.read(twoFaSignatureNotifierProvider.notifier).setSignature(signature);

      await wrapWithSignature(action, signature);

      return null;
    });
  }
}
