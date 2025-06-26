// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'two_fa_signature_notifier.r.g.dart';

@Riverpod(keepAlive: true)
class TwoFaSignatureNotifier extends _$TwoFaSignatureNotifier {
  @override
  String? build() => null;

  Future<void> setSignature(String? signature) async {
    state = signature;
  }
}
