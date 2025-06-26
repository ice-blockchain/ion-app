// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user/pages/switch_account_modal/components/accounts_list/account_tile.dart';

class AccountsList extends ConsumerWidget {
  const AccountsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateValue = ref.watch(authProvider).valueOrNull;

    if (authStateValue == null) {
      return const SizedBox.shrink();
    }

    return SeparatedColumn(
      separator: SizedBox(height: 16.0.s),
      children: authStateValue.authenticatedIdentityKeyNames
          .map((identityKeyName) => AccountsTile(identityKeyName: identityKeyName))
          .toList(),
    );
  }
}
