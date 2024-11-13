// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:ion/app/features/user/pages/switch_account_modal/components/action_button/action_button.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class ProfileSettingsModal extends ConsumerWidget {
  const ProfileSettingsModal({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch selected content languages
    final appLanguage = Language.values.first;
    final contentLanguages = Language.values.take(3).toList();

    final primaryColor = context.theme.appColors.primaryAccent;
    final items = <Widget>[
      ActionButton(
        icon: Assets.svg.iconProfileUser.icon(
          color: primaryColor,
        ),
        label: context.i18n.profile_settings_profile_edit,
        onTap: () {
          context
            ..go(ProfileRoute(pubkey: pubkey).location)
            ..go(ProfileEditRoute(pubkey: pubkey).location);
        },
      ),
      ActionButton(
        icon: Assets.svg.iconSelectLanguage.icon(
          color: primaryColor,
        ),
        label: context.i18n.profile_settings_app_language,
        trailing: Text(
          appLanguage.name,
          style: context.theme.appTextThemes.caption.copyWith(color: primaryColor),
        ),
        onTap: () {
          AppLanguagesRoute(pubkey: pubkey).push<void>(context);
        },
      ),
      ActionButton(
        icon: Assets.svg.iconSelectLanguage.icon(
          color: primaryColor,
        ),
        label: context.i18n.profile_settings_content_language,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              contentLanguages.first.name,
              style: context.theme.appTextThemes.caption.copyWith(color: primaryColor),
            ),
            if (contentLanguages.length > 1) ...[
              SizedBox(width: 12.0.s),
              _NumericLabel(value: '+ ${contentLanguages.length - 1}'),
            ],
          ],
        ),
        onTap: () {
          ContentLanguagesRoute(pubkey: pubkey).push<void>(context);
        },
      ),
    ];

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.profile_settings_profile_title),
            actions: [
              NavigationCloseButton(
                onPressed: () {
                  context.go(ProfileRoute(pubkey: pubkey).location);
                },
              ),
            ],
          ),
          ScreenSideOffset.small(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, i) => items[i],
              separatorBuilder: (context, _) => SizedBox(height: 9.0.s),
            ),
          ),
          ScreenBottomOffset(margin: 32.0.s),
        ],
      ),
    );
  }
}

class _NumericLabel extends StatelessWidget {
  const _NumericLabel({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.onTerararyFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: context.theme.appTextThemes.caption
            .copyWith(color: context.theme.appColors.primaryAccent),
      ),
    );
  }
}
