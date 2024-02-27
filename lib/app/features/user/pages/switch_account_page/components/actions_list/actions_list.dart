import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/pages/switch_account_page/components/actions_list/action_button.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class ActionsList extends HookConsumerWidget {
  const ActionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserData activeUser = ref.watch(userDataNotifierProvider);
    return Column(
      children: <Widget>[
        ActionButton(
          iconPath: Assets.images.icons.iconLoginCreateacc.path,
          label: context.i18n.profile_create_new_account,
          onTap: () {},
        ),
        ActionButton(
          iconPath: Assets.images.icons.iconLoginNostrstroke.path,
          label: context.i18n.profile_add_nostr_account,
          onTap: () {},
        ),
        ActionButton(
          iconPath: Assets.images.icons.iconMenuLogout.path,
          label: context.i18n.profile_log_out('@${activeUser.nickname}'),
          onTap: () {},
        ),
      ],
    );
  }
}
