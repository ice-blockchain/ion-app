// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/protect_account/secure_account/providers/two_fa_signature_notifier.c.dart';
import 'package:ion/app/services/providers/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'two_fa_signature_wrapper_notifier.c.g.dart';

typedef SignedAction = Future<void> Function(String? signature);

@Riverpod(keepAlive: true)
class TwoFaSignatureWrapperNotifier extends _$TwoFaSignatureWrapperNotifier {
  Completer<void>? _completer;

  @override
  FutureOr<SignedAction?> build() async => null;

  Future<void> wrapWithSignature(SignedAction action, [String? twoFaSignature]) async {
    _completer = Completer<void>();
    state = const AsyncLoading();

    try {
      final signature = twoFaSignature ?? ref.read(twoFaSignatureNotifierProvider);
      await action(signature);

      state = const AsyncValue.data(null);
      _completer?.complete();
    } on InvalidSignatureException {
      // set state with failed action to retry
      state = AsyncValue.data(action);
    } catch (e) {
      state = const AsyncValue.data(null);
      rethrow;
    }

    return _completer?.future;
  }

  Future<void> retryWithVerifyIdentity(
    SignedAction action,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  ) async {
    try {
      final client = await ref.read(ionIdentityClientProvider.future);
      final signature = await client.auth.generateSignature(onVerifyIdentity);
      await ref.read(twoFaSignatureNotifierProvider.notifier).setSignature(signature);

      await action(signature);
      _completer?.complete();
    } catch (e) {
      _completer?.completeError(e);
    }
  }
}
