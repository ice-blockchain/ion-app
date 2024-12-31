// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/modal_action_button/modal_action_button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class ProfileSettingsModal extends ConsumerWidget {
  const ProfileSettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentLanguages = Language.values.take(3).toList();
    final primaryColor = context.theme.appColors.primaryAccent;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.common_profile),
            actions: [
              NavigationCloseButton(
                onPressed: Navigator.of(context, rootNavigator: true).pop,
              ),
            ],
          ),
          ScreenSideOffset.small(
            child: SeparatedColumn(
              separator: SizedBox(height: 9.0.s),
              mainAxisSize: MainAxisSize.min,
              children: [
                ModalActionButton(
                  icon: Assets.svg.iconProfileUser.icon(
                    color: primaryColor,
                  ),
                  label: context.i18n.settings_profile_edit,
                  onTap: () {
                    ProfileEditRoute().go(context);
                  },
                ),
                ModalActionButton(
                  icon: Assets.svg.iconSelectLanguage.icon(
                    color: primaryColor,
                  ),
                  label: context.i18n.settings_app_language,
                  trailing: Text(
                    ref.watch(localePreferredLanguageProvider).name,
                    style: context.theme.appTextThemes.caption.copyWith(color: primaryColor),
                  ),
                  onTap: () {
                    AppLanguagesRoute().push<void>(context);
                  },
                ),
                ModalActionButton(
                  icon: Assets.svg.iconSelectLanguage.icon(
                    color: primaryColor,
                  ),
                  label: context.i18n.settings_content_language,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        contentLanguages.first.name,
                        style: context.theme.appTextThemes.caption.copyWith(color: primaryColor),
                      ),
                      if (contentLanguages.length > 1) ...[
                        SizedBox(width: 12.0.s),
                        _RemainingLanguagesLabel(
                          value: contentLanguages.length - 1,
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    ContentLanguagesRoute().push<void>(context);
                  },
                ),
              ],
            ),
          ),
          ScreenBottomOffset(margin: 32.0.s),
        ],
      ),
    );
  }
}

class _RemainingLanguagesLabel extends StatelessWidget {
  const _RemainingLanguagesLabel({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.onTerararyFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        context.i18n.settings_remaining_content_languages_number(value),
        style: context.theme.appTextThemes.caption
            .copyWith(color: context.theme.appColors.primaryAccent),
      ),
    );
  }
}
