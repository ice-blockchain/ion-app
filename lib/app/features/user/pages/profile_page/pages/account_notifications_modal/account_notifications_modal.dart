// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/providers/user_notifications_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/generated/assets.gen.dart';

class AccountNotificationsModal extends HookConsumerWidget {
  const AccountNotificationsModal({
    required this.selectedUserNotificationsTypes,
    super.key,
  });

  final List<UserNotificationsType> selectedUserNotificationsTypes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;
    final selectedOptions = useState<Set<UserNotificationsType>>(
      selectedUserNotificationsTypes.toSet(),
    );

    final handleOptionSelection = useCallback(
      (UserNotificationsType option) {
        selectedOptions.value = UserNotificationsType.toggleNotificationType(
          selectedOptions.value,
          option,
        );

        ref
            .read(userNotificationsNotifierProvider.notifier)
            .updateNotifications(selectedOptions.value.toList());
      },
      [selectedOptions, ref],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.profile_notifications_popup_title),
        ),
        const HorizontalSeparator(),
        for (final UserNotificationsType option in UserNotificationsType.values.toSet())
          Column(
            children: [
              MenuItemButton(
                onPressed: () => handleOptionSelection(option),
                leadingIcon: ButtonIconFrame(
                  containerSize: 36.0.s,
                  borderRadius: BorderRadius.circular(10.0.s),
                  color: colors.onSecondaryBackground,
                  icon: option.iconAsset.icon(
                    size: 24.0.s,
                    color: colors.primaryAccent,
                  ),
                  border: Border.fromBorderSide(
                    BorderSide(color: colors.onTerararyFill, width: 1.0.s),
                  ),
                ),
                trailingIcon: selectedOptions.value.contains(option)
                    ? Assets.svg.iconBlockCheckboxOnblue.icon(
                        color: colors.success,
                      )
                    : Assets.svg.iconBlockCheckboxOff.icon(
                        color: colors.tertararyText,
                      ),
                child: Text(
                  option.getTitle(context),
                  style: textStyles.body,
                ),
              ),
              const HorizontalSeparator(),
            ],
          ),
        ScreenBottomOffset(),
      ],
    );
  }
}
