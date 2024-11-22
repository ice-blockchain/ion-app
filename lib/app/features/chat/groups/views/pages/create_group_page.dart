// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/features/chat/groups/providers/create_group_form_controller_provider.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateGroupPage extends ConsumerWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createGroupForm = ref.watch(createGroupFormControllerProvider);
    final nameController = useTextEditingController(
      text: ref.watch(createGroupFormControllerProvider).title,
    );
    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: const Text('New group'),
            actions: [
              NavigationCloseButton(
                onPressed: Navigator.of(context, rootNavigator: true).pop,
              ),
            ],
          ),
          SizedBox(height: 27.0.s),
          Expanded(
            child: ScreenSideOffset.small(
              child: SeparatedColumn(
                separator: SizedBox(height: 24.0.s),
                children: [
                  Row(
                    children: [
                      AvatarPicker(
                        avatarSize: 58.0.s,
                        iconBackgroundSize: 21.0.s,
                        iconSize: 14.0.s,
                      ),
                      SizedBox(width: 16.0.s),
                      Expanded(
                        child: GeneralUserDataInput(
                          controller: nameController,
                          prefixIconAssetName: Assets.svg.iconFieldName,
                          labelText: 'Group Name',
                        ),
                      ),
                    ],
                  ),
                  GeneralSelectionButton(
                    iconAsset: Assets.svg.iconChannelType,
                    title: 'Group type',
                    selectedValue: createGroupForm.type.getTitle(context),
                    onPress: () async {},
                  ),
                  Row(
                    children: [
                      Assets.svg.iconCategoriesFollowing.icon(size: 16.0.s),
                      SizedBox(width: 6.0.s),
                      Text('Group members (${createGroupForm.members.length})'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'edit',
                          style: context.theme.appTextThemes.caption.copyWith(
                            color: context.theme.appColors.primaryAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: copy/paste from another pr. Remove it after rebase.
class GeneralSelectionButton extends StatelessWidget {
  const GeneralSelectionButton({
    required this.iconAsset,
    required this.title,
    required this.onPress,
    this.selectedValue,
    super.key,
  });

  final String iconAsset;
  final String title;
  final String? selectedValue;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;

    final hasSelection = selectedValue != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.strokeElements),
        borderRadius: BorderRadius.circular(16.0.s),
        color: colors.secondaryBackground,
      ),
      child: ListItem(
        contentPadding: EdgeInsets.only(
          right: 8.0.s,
        ),
        title: Text(
          title,
          style: textTheme.body.copyWith(
            color: hasSelection ? colors.primaryText : colors.tertararyText,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: TextInputIcons(
          hasRightDivider: true,
          icons: [iconAsset.icon(color: colors.secondaryText)],
        ),
        onTap: onPress,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedValue != null)
              Text(
                selectedValue!,
                style: textTheme.body.copyWith(color: colors.primaryAccent),
              ),
            GestureDetector(
              onTap: onPress,
              child: Padding(
                padding: EdgeInsets.all(4.0.s),
                child: Assets.svg.iconArrowRight.icon(color: colors.secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
