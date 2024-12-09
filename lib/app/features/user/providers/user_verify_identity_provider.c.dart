// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_confirm_password_dialog.dart';
import 'package:ion/app/features/user/model/verify_identity_type.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_verify_identity_provider.c.g.dart';

// It is without code generation here cause code generation for providers can't handle generics
AutoDisposeFutureProvider<T> verifyUserIdentityProvider<T>({
  required BuildContext context,
  required OnPasswordFlow<T> onPasswordFlow,
  required OnPasskeyFlow<T> onPasskeyFlow,
}) {
  return FutureProvider.autoDispose<T>((ref) async {
    final username = ref.read(currentIdentityKeyNameSelectorProvider)!;
    final ionIdentity = await ref.read(ionIdentityProvider.future);
    final isPasswordFlowUser = ionIdentity(username: username).auth.isPasswordFlowUser();

    if (isPasswordFlowUser) {
      if (context.mounted) {
        final password = await showSimpleBottomSheet<String>(
          context: context,
          child: const VerifyIdentityConfirmPasswordDialog(),
        );
        if (password != null) {
          return onPasswordFlow(password: password);
        }
      }
      throw VerifyIdentityException();
    } else {
      return onPasskeyFlow();
    }
  });
}

@riverpod
Future<VerifyIdentityType> verifyIdentityType(Ref ref) async {
  final username = ref.read(currentIdentityKeyNameSelectorProvider);
  final ionIdentity = await ref.read(ionIdentityProvider.future);
  if (username != null) {
    return ionIdentity(username: username).auth.isPasswordFlowUser()
        ? VerifyIdentityType.password
        : VerifyIdentityType.passkey;
  }
  return (await ionIdentity(username: '').auth.isPasskeyAvailable())
      ? VerifyIdentityType.passkey
      : VerifyIdentityType.password;
}

@riverpod
Future<bool> isPasskeyAvailable(Ref ref) async {
  final ionIdentity = await ref.read(ionIdentityProvider.future);
  return ionIdentity(username: '').auth.isPasskeyAvailable();
}
