// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/features/chat/groups/providers/create_group_form_controller_provider.dart';
import 'package:ion/app/features/chat/groups/views/components/group_participant_list_item.dart';
import 'package:ion/app/features/chat/groups/views/pages/group_type_selection_model.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateGroupPage extends HookConsumerWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createGroupForm = ref.watch(createGroupFormControllerProvider);
    final nameController = useTextEditingController(text: createGroupForm.title);
    final members = createGroupForm.members.toList();

    useEffect(
      () {
        void updateTitle() {
          ref.read(createGroupFormControllerProvider.notifier).title = nameController.text;
        }

        nameController.addListener(updateTitle);
        return () => nameController.removeListener(updateTitle);
      },
      [nameController],
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
              child: Column(
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
                  SizedBox(height: 24.0.s),
                  GeneralSelectionButton(
                    iconAsset: Assets.svg.iconChannelType,
                    title: 'Group type',
                    selectedValue: createGroupForm.type.getTitle(context),
                    onPress: () {
                      showSimpleBottomSheet<void>(
                        context: context,
                        child: GroupTypeSelectionModal(
                          groupType: createGroupForm.type,
                          onUpdated: (type) {
                            ref
                                .read(
                                  createGroupFormControllerProvider.notifier,
                                )
                                .type = type;
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.0.s),
                  Row(
                    children: [
                      Assets.svg.iconCategoriesFollowing.icon(size: 16.0.s),
                      SizedBox(width: 6.0.s),
                      Text('Group members (${members.length})'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          AddParticipantsToGroupModalRoute().go(context);
                        },
                        child: Text(
                          'edit',
                          style: context.theme.appTextThemes.caption.copyWith(
                            color: context.theme.appColors.primaryAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0.s),
                  Expanded(
                    child: ListView.separated(
                      itemCount: members.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.0.s),
                      itemBuilder: (BuildContext context, int i) =>
                          GroupMemberListItem(member: members[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const HorizontalSeparator(),
          SizedBox(height: 16.0.s),
          ScreenBottomOffset(
            margin: 32.0.s,
            child: ScreenSideOffset.large(
              child: Button(
                type: createGroupForm.canCreate ? ButtonType.primary : ButtonType.disabled,
                mainAxisSize: MainAxisSize.max,
                minimumSize: Size(56.0.s, 56.0.s),
                leadingIcon: Assets.svg.iconPlusCreatechannel.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
                label: const Text('Create group'),
                onPressed: () {},
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
