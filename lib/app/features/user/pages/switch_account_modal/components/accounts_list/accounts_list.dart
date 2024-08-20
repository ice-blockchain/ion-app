import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/pages/switch_account_modal/components/accounts_list/account_tile.dart';
import 'package:ice/app/features/user/providers/users_data_provider.dart';

class AccountsList extends ConsumerWidget {
  const AccountsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersData = ref.watch(usersDataNotifierProvider);
    return Column(
      children: usersData.values
          .map(
            (UserData userData) => AccountsTile(
              userData: userData,
            ),
          )
          .toList(),
    );
  }
}
