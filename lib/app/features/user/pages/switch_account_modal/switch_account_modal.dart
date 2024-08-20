import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/pages/switch_account_modal/components/accounts_list/accounts_list.dart';
import 'package:ice/app/features/user/pages/switch_account_modal/components/action_button/action_button.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';

class SwitchAccountModal extends ConsumerWidget {
  const SwitchAccountModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUser = ref.watch(userDataNotifierProvider);
    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.profile_switch_user_header),
              actions: const [
                NavigationCloseButton(),
              ],
            ),
            ActionButton(
              icon: Assets.images.icons.iconLoginCreateacc.icon(),
              label: context.i18n.profile_create_new_account,
              onTap: () {},
            ),
            ScreenSideOffset.small(child: const AccountsList()),
            ActionButton(
              icon: Assets.images.icons.iconMenuLogout.icon(),
              label: context.i18n.profile_log_out(
                prefixUsername(
                  username: activeUser.nickname,
                  context: context,
                ),
              ),
              onTap: () {
                ref.read(authProvider.notifier).signOut();
              },
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}
