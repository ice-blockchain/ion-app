// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/general_user_data_input.dart';
import 'package:ion/app/features/chat/model/group.dart';
import 'package:ion/app/features/chat/model/group_type.dart';
import 'package:ion/app/features/chat/providers/create_group_form_controller_provider.dart';
import 'package:ion/app/features/chat/providers/groups_provider.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_provider.dart';
import 'package:ion/app/features/chat/views/components/general_selection_button.dart';
import 'package:ion/app/features/chat/views/components/type_selection_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_group_modal/componentes/group_participant_list_item.dart';
import 'package:ion/app/features/components/avatar_picker/avatar_picker.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateGroupModal extends HookConsumerWidget {
  const CreateGroupModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);
    final createGroupForm = ref.watch(createGroupFormControllerProvider);
    final createGroupFormNotifier = ref.watch(createGroupFormControllerProvider.notifier);
    final nameController = useTextEditingController(text: createGroupForm.name);
    final members = createGroupForm.members.toList();

    useEffect(
      () {
        void updateTitle() {
          createGroupFormNotifier.title = nameController.text;
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
            title: Text(context.i18n.group_create_title),
            actions: [
              NavigationCloseButton(
                onPressed: Navigator.of(context, rootNavigator: true).pop,
              ),
            ],
          ),
          SizedBox(height: 27.0.s),
          Expanded(
            child: Form(
              key: formKey,
              child: ScreenSideOffset.small(
                child: Column(
                  children: [
                    Row(
                      children: [
                        AvatarPicker(
                          avatarSize: 58.0.s,
                          iconSize: 14.0.s,
                          iconBackgroundSize: 21.0.s,
                        ),
                        SizedBox(width: 16.0.s),
                        Expanded(
                          child: GeneralUserDataInput(
                            controller: nameController,
                            prefixIconAssetName: Assets.svg.iconFieldName,
                            labelText: context.i18n.group_create_name_label,
                            validator: (String? value) {
                              if (Validators.isEmpty(value)) return '';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0.s),
                    GeneralSelectionButton(
                      iconAsset: Assets.svg.iconChannelType,
                      title: context.i18n.group_create_type,
                      selectedValue: createGroupForm.type.getTitle(context),
                      onPress: () {
                        showSimpleBottomSheet<void>(
                          context: context,
                          child: TypeSelectionModal(
                            title: context.i18n.group_create_type_title,
                            values: GroupType.values,
                            initiallySelectedType: createGroupForm.type,
                            onUpdated: (type) {
                              createGroupFormNotifier.type = type;
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
                        Text(
                          context.i18n.group_create_members_number(members.length),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            AddParticipantsToGroupModalRoute().go(context);
                          },
                          child: Text(
                            context.i18n.button_edit,
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
                        itemBuilder: (_, int i) {
                          final member = members[i];

                          return GroupMemberListItem(
                            isCurrentPubkey: member == currentPubkey,
                            onRemove: () {
                              createGroupFormNotifier.toggleMember(member);
                            },
                            pubkey: member,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const HorizontalSeparator(),
          SizedBox(height: 16.0.s),
          ScreenBottomOffset(
            margin: 32.0.s,
            child: ScreenSideOffset.large(
              child: Button(
                mainAxisSize: MainAxisSize.max,
                minimumSize: Size(56.0.s, 56.0.s),
                leadingIcon: Assets.svg.iconPlusCreatechannel.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                ),
                label: Text(context.i18n.group_create_create_button),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final newGroup = Group(
                      id: 'new_group',
                      link: 'https://ice.io/testers_group',
                      name: createGroupForm.name!,
                      type: createGroupForm.type,
                      members: createGroupForm.members.toList(),
                      image: ref.read(avatarProcessorNotifierProvider).mapOrNull(
                            cropped: (file) => file.file,
                            processed: (file) => file.file,
                          ),
                    );

                    ref.read(groupsProvider.notifier).setGroup(newGroup.id, newGroup);
                    ref.read(conversationsProvider.notifier).addGroupConversation(newGroup);
                    GroupRoute(pubkey: newGroup.id).replace(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
