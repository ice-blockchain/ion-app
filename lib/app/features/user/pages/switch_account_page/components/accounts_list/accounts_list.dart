import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/pages/switch_account_page/components/accounts_list/account_tile.dart';
import 'package:ice/app/features/user/providers/users_data_provider.dart';

class AccountsList extends HookConsumerWidget {
  const AccountsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, UserData> usersData =
        ref.watch(usersDataNotifierProvider);
    return Padding(
      padding: EdgeInsets.only(top: 8.0.s),
      child: Column(
        children: usersData.values
            .map(
              (UserData userData) => AccountsTile(
                userData: userData,
              ),
            )
            .toList(),
      ),
    );
  }
}
