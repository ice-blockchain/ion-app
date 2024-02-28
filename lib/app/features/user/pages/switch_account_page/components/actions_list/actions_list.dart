import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
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
          icon: Assets.images.icons.iconLoginCreateacc.icon(),
          label: context.i18n.profile_create_new_account,
          onTap: () {},
        ),
        ActionButton(
          icon: Assets.images.icons.iconLoginNostrstroke.icon(),
          label: context.i18n.profile_add_nostr_account,
          onTap: () {},
        ),
        ActionButton(
          icon: Assets.images.icons.iconMenuLogout.icon(),
          label: context.i18n.profile_log_out('@${activeUser.nickname}'),
          onTap: () {},
        ),
      ],
    );
  }
}
